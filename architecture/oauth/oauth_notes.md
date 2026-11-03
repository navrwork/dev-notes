# OAuth Demo App

## Reference
* [OAuth.net](https://oauth.net/2/)
* [What is OAuth 2.0? | auth0.com](https://auth0.com/intro-to-iam/what-is-oauth-2)
* [Auth0 dashboard | auth0.com](https://manage.auth0.com/dashboard)
* [Modern Guide to OAuth](https://fusionauth.io/articles/oauth/modern-guide-to-oauth)
* [Udemy course by Aaron Parecki](https://www.udemy.com/course/oauth-2-simplified/)
  * [Companion to the Udemy course | oauth.school](https://oauth.school/)
* [OAuth 2.0 Playground | oauth.com](https://www.oauth.com/playground/)

## Sample OAuth App
* [My sample OAuth MVC app | github.com](https://github.com/navrwork/spring-mvc/oauthdemo)

## OAuth Basics
* Before OAuth: HTTP Basic auth - Send username and password to the API. Application had to ask the user for password, store it and use the password in API request. This means, 3rd party apps need to request for and store the user credentials to access the API.
* OAuth 2.0: OAuth (short for "Open Authorization" ) is an open standard for access delegation, commonly used as a way for internet users to grant websites or applications access to their information on other websites but without giving them the passwords.
* OAuth Access Token: The application using the access token doesn’t need to know anything about how it works. Applications should just use the access token in an API request and let the API figure out if it’s valid.
* Roles in OAuth
    * User / Resource Owner
    * Device / User Agent
    * 3rd party app / OAuth client
    * Authorization server
    * API / Resource server
* Note that these are roles and not necessarily distinct components. For example, in smaller systems, you might have an API with a built in OAuth server, all part of the same code base and all deploy on a single server.

### Authorization server:
* The job of the authorization server is to manage access to the API that it's protecting. 
* And the way it will do that is by getting the user to log in at the authorization server and then creating an access token and giving that access token to the app. That way, the app is never going to see the user's password. 
* The 3rd party app will then use the access token to make an API request, which means the API is going to need some way to validate that access token.

### Resource Server
* If a bunch of microservices make up your APIs, then microservices are all part of the role of the resource server. 
* If you also have an API gateway out in front of them, then everything behind the gateway is clearly a resource server.


## OAuth vs OpenID Connect
* OAuth is about accessing APIs and OpenID is about identifying users.
* OAuth only provides the application with an access token. OpenID Connect was created as an extension of OAuth in order to provide the application with the user’s identity information.
* OpenID Connect takes OAuth as a foundation, and it adds in user identity information on top. OpenID Connect is an extension of OAuth and that extension provides a mechanism where the OAuth server can actually communicate data about the user back to the application.
* OAuth issues access tokens to apps, OpenID Connect issues ID tokens to apps. And the ID Token is a statement about the user.

## Front and Back Channels
* Front-Channel: Code redirects the user's browser to the auth-server URL;
* Back-Channel (not related to backend): client-server flow; Using a fetch() or ajax call is a back-channel use-case.

## Auth Code flow
* Client has to prove its identity, at auth server, by passing in client secret. Only then auth server would share the access code back.
* However, mobile apps or a single page apps which can't be deployed with a client secret since these kinds of applications don't have a client secret. It turns out that PKCE extension, short for Proof Key for Code Exchange, is a solution to this.

## Auth0 developer account
* Sign up for an Auth0 developer account. Visit https://auth0.com and sign up for an account.
* Visit https://oauth.school/exercise/introduction/ for more info.


## Register client at OAuth server
* If you are ready to build an OAuth client, you're going to need to register the client at that OAuth server.
* Client registration is a step of registering the app's identity at the server. 
* To register, go to the developer website for the service you're writing an app for. Register as a developer and then go create applications.
* When you go to register the app, the server will ask for some information about your app like below:
  * Name of the app
  * One or more redirect URLs for the app. This is a critical piece of information during the registration.
  * Description of the app and/or logo of the app
  * And if it's a public API, there might also be a place to link to the app's terms of service or privacy policy.
  * OAuth server may ask you the type of app. Depending on what you choose, it may decide different policies around whether refresh tokens are issued or might enable CORS headers for JavaScript apps, for example.

