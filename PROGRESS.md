```bash
~/Work/zap zapext* ❯ zap https://jsonplaceholder.typicode.com/posts/1
GET https://jsonplaceholder.typicode.com/posts/1
        ↳ 200 OK | 0.135756066s
        ↳ {
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
~/Work/zap zapext* ❯ zap http://jsonplaceholder.typicode.com/posts/1
GET http://jsonplaceholder.typicode.com/posts/1
        ↳ 200 OK | 0.54824894s
        ↳ {
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
~/Work/zap zapext* ❯ zap jsonplaceholder.typicode.com/posts/1
GET https://jsonplaceholder.typicode.com/posts/1
        ↳ 200 OK | 0.076043205s
        ↳ {
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
~/Work/zap zapext* ❯ zap -fh jsonplaceholder.typicode.com/posts/1
GET http://jsonplaceholder.typicode.com/posts/1
        ↳ 200 OK | 0.032015779s
        ↳ {
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
```
