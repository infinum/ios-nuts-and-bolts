# Networking with Japx

[Japx](https://github.com/infinum/Japx) is lightweight JSON:API parser that flattens complex JSON:API structure and turns it into simple JSON and vice versa.

## Example

This example will cover how to handle basic CRUD (Create, Read, Update, Delete) operations with Japx because API expects JSON:API format. 

### Model

Struct definition that API requires is given with PokedexUser.

```swift
struct PokedexUser: JapxCodable {

    let id: String
    let type: String = "users"

    let email: String?
    let username: String?
    let password: String?
    let passwordConfirmation: String?
    let authToken: String?
}
```

PokedexUser conforms to JapxCodable protocol which is typealias for JapxDecodable and JapxEncodable. This is just extension of Codable protocol with additional required properties `type` and `id`. 
Encoding this model with JapxEncoder will transform it into [String: Any] dictionary which is then encoded with JSONEncoder to convert it into JSON. JSON example for updating users email and username:

```json
{
    "data": {
        "id": "80",
        "type": "users",
        "attributes": {
            "email": "new-email@gmail.com",
            "username": "username-79"
        },
        "relationships": {}
    }
}
```

### Router

PokedexRouter class defines information required to send successful requests to the API. There are 4 different router functions (for each operation). Example of the router usage for updating user properties:

```swift
static func updateUser(id: String, email: String?, username: String?) -> PokedexRouter {

    let pokedexUser = PokedexUser(id: id, email: email, username: username)

    let params = try? JapxEncoder().encode(pokedexUser)
    let encodableParam = EncodableParams(encoding: JSONEncoding.default, parameters: params)

    return PokedexRouter(
        baseUrl: "https://pokeapi.infinum.co/api/v1",
        path: "/users/\(id)",
        method: .put,
        encodableParams: [encodableParam]
    )
}
```

### Interactor

Base `API service` class is used for communicating with API. It contains function `requestJSONAPI` which sends request, validates given response and returns result of your Decodable object through completion.

```swift
func requestJSONAPI<T: Decodable>(
    _: T.Type,
    includeList: String? = nil,
    keyPath: String? = nil,
    decoder: JapxDecoder = JapxDecoder(jsonDecoder: .init()),
    router: Routable,
    sessionManager: SessionManager,
    completion: @escaping (Result<T>) -> ()
    ) -> DataRequest {
        return sessionManager
        .request(router)
        .validate()
        .responseCodableJSONAPI(
            includeList: includeList,
            keyPath: keyPath,
            decoder: decoder,
            completionHandler: { completion($0.result) }
        )
    }
}
``` 

If keypath is specified with "data" (root of JSON:API format) then you can simply pass on your model, in this case `PokedexUser`, as a generic Decodable. Otherwise use `JapxResponse` which has your model in the data property.

```swift
func updateUser(
    id: String, 
    email: String?, 
    username: String?, 
    completion: @escaping (Result<PokedexUser>) -> Void
) -> DataRequest {
    let router = PokedexRouter.updateUser(id: id, email: email, username: username)

    return service
        .requestJSONAPI(
            PokedexUser.self,
            keyPath: "data",
            router: router,
            sessionManager: sessionManager,
            completion: completion
    )
}

public struct JapxResponse<T: Codable>: Codable {
    public let data: T
}
```
