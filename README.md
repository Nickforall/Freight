# Freight

![https://api.travis-ci.com/Nickforall/Freight.svg?branch=master](https://api.travis-ci.com/Nickforall/Freight.svg?branch=master)

Freight is a library for [Absinthe GraphQL](http://absinthe-graphql.org/) that helps you build mutation payload results. Inspired by the GraphQL APIs of [GitHub](https://developer.github.com/v4/breaking_changes/) and [Shopify](https://gist.github.com/swalkinshaw/3a33e2d292b60e68fcebe12b62bbb3e2), who also aim to keep syntactical GraphQL errors, like missing fields and malformed queries, seperate from validation and other business logic errors.

It is heavily inspired by [Kronky](https://github.com/Ethelo/kronky), I decided to build my own library because I did not like how much it is focussed on ecto changesets, and missed customisability that was required for a project I work on.

## Configuration

You can set a custom error object that will be returned in the errors array in your payloads. This object must be defined in the schema you're calling `define_payload` from.

```elixir
config :freight,
  error_object: :user_error
  # whenever a field is snake-cased (like an ecto field for example), setting this to `true` will camelize it like Absinthe would
  lower_camelize_field_name: true
```

## Usage

Below is a documented example of how to define Freight payloads in your schema

```elixir
defmodule FreightDemo.Schema.Example do
  use Absinthe.Schema.Notation

  import Freight.Payload

  object :user do
    field(:name, :string)
  end

  object :comment do
    field(:body, :string)
    field(:author, :user)
  end

  define_payload(:create_comment_payload, author: :user, comment: :comment)

  field :create_comment, type: :create_comment_payload do
    arg(:body, non_null(:string))

    resolve(&FreightDemo.Resolver.create_comment/3)
    middleware(&build_payload/2)
  end
end
```

Returning errors works just like in Absinthe

```elixir
defmodule FreightDemo.Resolver do
  def create_comment(_parent, %{body: body}, _context) do
    # your logic

    {:ok, author: %{}, comment: %{}}
  end

  # OR

  def create_comment(_parent, %{body: body}, _context) do
    # your logic

    {:error, "Something went horribly wrong!"}
  end
end
```

More extensive documentation on defining errors can be found in the [documentation](https://hexdocs.pm/freight)

## Installation

Add the following to your `mix.exs file`

```elixir
def deps do
  [
    {:freight, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/freight](https://hexdocs.pm/freight).
