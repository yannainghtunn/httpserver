
# Deep dive into Http Servers

Let's explore how http servers work. How Browser comunicate with http servers.

## TCP Connection

TCP is a connection. It established connection before is send data between server and client.

### Let's create a  simple TCP Connection
#### First Install `nc`
For Linux
```bash
  ~$ sudo apt-get install netcat
```
For Windows
 [Download Netcat For Windows](https://eternallybored.org/misc/netcat/netcat-win32-1.11.zip)

#### Create TCP Server And Connect To That Server
```bash
  ~$ nc -l 4444
  # This comment will create tcp connection on port 4444.

  ~$ nc 127.0.0.1 4444
  # Connect to port 4444 at 127.0.0.1 address.
```

### HTTP Methods 
- `CONNECT` - create two way communication.
- `GET` - It is used to request data.
- `POST` - Send data to server.
- `PUT` - Create new resource.
- `DELETE` - Delete resource.
- `OPTIONS` - Return list of allowed http methods.
- `PATCH` - Modify Resource.
- `HEAD` - Only return headers for GET Method. Useful to read Content-Lenght for download size.
- `TRACE` - Debug web server connection.


#### Make `GET` request with `nc` command.
```bash
  ~$ nc www.google.com 80
  GET / HTTP/1.1
  Host: www.google.com
```

#### Make `POST` request with `nc` command.
`POST` with json
```bash
  ~$ nc www.google.com 80
  POST / HTTP/1.1
  Host: www.google.com
  Content-Type: application/json

  {
    "name": "Yan Naing Htun",
    "email": "kishan@gmail.com"
  }
```

#### Let's see what browser send to tcp server.
Open tcp connection at your prefered port number.
For me it's 4444 :)
```bash
  ~$ nc -lv 4444
  Listening on 0.0.0.0 4444

  # in -lv v is for verbose.
```
Go to browser and enter `"http://127.0.0.1:4444/"`.

You will see like below in your `nc -lv 4444` terminal.

```bash
  ~$ nc -lv 4444
  Listening on 0.0.0.0 4444
  Connection received on localhost 46284
  GET / HTTP/1.1
  Host: 127.0.0.1:4444
  Connection: keep-alive
  sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="102", "Google Chrome";v="102"
  sec-ch-ua-mobile: ?0
  sec-ch-ua-platform: "Linux"
  Upgrade-Insecure-Requests: 1
  User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
  Sec-Fetch-Site: none
  Sec-Fetch-Mode: navigate
  Sec-Fetch-User: ?1
  Sec-Fetch-Dest: document
  Accept-Encoding: gzip, deflate, br
  Accept-Language: en-US,en;q=0.9
  Cookie: _ga=GA1.1.947926618.1655743159
```

As, you can see there are many headers browser send to servers by default.

Let's understand those by reading below HTTP Header section.

## HTTP Headers
### `Host` Header
Let's understand `Host` header.

How browser know where is `www.google.com`.
Browser will first get ip of `www.google.com` from dns server.
Then it will send data - "GET request or something" to that ip. If `http` is used then data is send to `ip:80`.
If `https` is used then `ip:443`.

So, what is use of `Host` header?

Actually there is not only `www.google.com` behind ip of `www.google.com` multiple web app are hosted on same ip.
If user visit to `www.youtube.com`, it is same as visiting to ip of `www.google.com` with Host header as `Host: www.youtube.com`. Because, google also hosted youtube with same ip configuration.

Let's see an example.
```bash
  ~$ nc www.google.com 80
  GET / HTTP/1.1
  Host: www.google.com

  # You will get Google's HTML Page

  ~$ nc www.google.com 80
  GET / HTTP/1.1
  Host: www.youtube.com

  # But for this case you will get Youtube's page.
  # Because, we set Host as www.youtube.com.
```
If you want to get the ip of a host you can run below command.
```bash
  ~$ ping www.google.com
  PING www.google.com (74.125.200.99) 56(84) bytes of data.
  64 bytes from sa-in-f99.1e100.net (74.125.200.99): icmp_seq=1 ttl=104 time=205 ms
  64 bytes from sa-in-f99.1e100.net (74.125.200.99): icmp_seq=2 ttl=104 time=62.5 ms
  ...
```

### `Content-Type` Header

`Content-Type` header is the only way for browser to know which content type server is sending back.
Like if this is `HTML`,`PNG`,`JS`,`CSS` or something else.

- `Content-Type: text/html` is in response, then browser interpret response as html code.
- `Content-Type: application/json` then browser understand this as json file.

More Content-Types? [See Full List](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types)

### `Cookie` header
It is to maintain info in browser. It is saved along with domain name.
`Cookie` header is always send by browser to server in every request.

So, how `Cookie` data can be set?  
It can be set by `javascript` code or response header `set-cookie`.
`set-cookie` is usefull is server want to set cookie in browser.

[Learn More About Cookie?](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie)

## Let's Create a simple http server in `nc` command.
First create a file `hello.txt`  
with below text:
```html
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: Yan's Server

<!DOCTYPE html>
<html>
    <body>
        <h1>Hello World</h2>
        <h4>Running on Server: Yan's Server</h4>
    </body>
</html>
```

After created, Run below command to start server.
```bash
  ~$ while true; do cat hello.txt | nc -l 4444 -w 1; done
```

Well. You have successfully created a simple http server.  
Open browser and enter `http://localhost:4444` to see your page.

## Run Dart-Server From This Repo
It is just a very basic implementation of http server in dart lang.
```bash 
   ~$ git clone https://github.com/yannainghtunn/httpserver.git
   ~$ cd httpserver
   ~$ dart run main.dart
```

## Benchmarks
Let's Benchmarks dart server (I have created) and php server.

First install following.
```bash
  ~$ sudo apt install apache2-utils
```

Now start dart server.
```bash
  ~$ cd httpserver
  ~$ dart run main.dart
  Server Listening: http://127.0.0.1:4444/
```
Run following command to benchmarks.
```bash
  ~$ ab -n 10000 -c 1000 http://localhost:4444/
```

So, you have done for dart part.  
#### Now benchmarks with php.
Run following command.
```bash
  ~$ cd httpserver
  ~$ php -S localhost:8080
  ~$ ab -n 10000 -c 1000 http://localhost:8080/
```

You have also done for php part.

***

Now compare this two result. You will see that php is more faster than dart server.  
This is because dart is async and php is mulithreaded.  


So, what is benefit of using async like server?  
These server can give benefits if there is a lot of network calls in server like database call, api calls, etc,.




## Contributing

Contributions are always welcome!

## Feedback

If you have any feedback, please reach out to me at yannainghtun112358@gmail.com

