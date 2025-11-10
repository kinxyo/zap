@baseURL https://api.example.com

#body {
    email: $env.ZAP_EMAIL
    password: $env.ZAP_PSWD
}

@auth {
  H-Key: Authorization
  H-Value: Bearer $token
  Body: body
  Source: /login
  Field: $resp.data.token
}

@glHeaders {
  X-API-Version: 2.0
}

GET /users
  expect status == 200
  expect json.length > 0

POST /users
  body { "name": "test" }
  content text
  expect status == 201
  expect text == "created!"
