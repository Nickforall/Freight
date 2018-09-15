# Changelog
## 0.2.0

**Added:**
* Ecto integration, which generates error messages from failed changesets
* Errors array is no longer nullable, and now always returns an array
* Errors are now an object instead of a string
* Successful field is no longer nullable
* Configurable error objects in the errors array using application env