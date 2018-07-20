This is just a simple POST-server written in Node.js.
It just accepts any POST request and logs the request-body to console.

See [server.js][0].

#### Running this server:

* Install [Node.js/NPM][1].
* Run the following commands:

```Bash
npm install # Install node packages
node start # Run the server
```

#### Running using Docker-Compose

* Use the provided `docker-compose.yml` to run using Docker-Compose.
* Command:
```Bash
docker-compose -f "<path-to-this-directory>/docker-compose.yml" up -d
```

  [0]: https://github.com/Jaskaranbir/aws_terraform_ansible/blob/master/ansible/docker/test_post-server/server.js
  [1]: https://nodejs.org/en/
