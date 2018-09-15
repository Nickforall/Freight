defmodule Freight.IntegrationTests.PayloadTest do
  defmodule Resolver do
    @user %{
      name: "Nicholas",
      email: "nick@awkward.co"
    }

    @post %{
      user: @user,
      title: "A cool thing"
    }

    def create_post(_, %{fails: false}, _) do
      {:ok, user: @user, post: @post}
    end

    def create_post(_, %{fails: true}, _) do
      {:error, "Something went wrong."}
    end
  end

  defmodule Schema do
    use Absinthe.Schema
    import Freight.Payload

    object :user do
      field(:name, :string)
      field(:email, :string)
    end

    object :post do
      field(:user, :user)
      field(:title, :string)
    end

    define_payload(:create_post_payload, user: :user, post: :post)

    query do
    end

    mutation do
      field :create_post, :create_post_payload do
        arg(:title, :string)
        arg(:fails, :boolean)

        resolve(&Resolver.create_post/3)
        middleware(&build_payload/2)
      end
    end
  end

  use ExUnit.Case, async: true

  def mutation(fails) do
    """
      mutation {
        createPost(title: \"A title\", fails: #{fails}) {
          successful
          user {
            name
          }
          post {
            title
          }
          errors {
            message
          }
        }
      }
    """
  end

  describe "Integration testing" do
    test "{:ok, _} with multiple fields" do
      {:ok, data} =
        mutation(false)
        |> Absinthe.run(Schema)

      data = data[:data]["createPost"]

      assert data["post"]["title"] == "A cool thing"
      assert data["user"]["name"] == "Nicholas"
      assert data["successful"] == true
    end

    test "{:error, _} with single error" do
      {:ok, data} =
        mutation(true)
        |> Absinthe.run(Schema)

      data = data[:data]["createPost"]

      assert !Map.get(data, "successful")
      assert List.first(data["errors"])["message"] == "Something went wrong."
    end
  end
end
