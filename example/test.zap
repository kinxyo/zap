@baseURL https://api.example.com
@auth Bearer xxx
@headers {
  X-API-Version: 2.0
}

GET /users
  expect status 200
  expect json.length > 0

POST /users
  body { name: test }
  content text
  expect status 201
  expect text == "created!"
