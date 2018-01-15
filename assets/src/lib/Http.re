type t = {
  json: Js.Json.t,
  status: int
};

let jsonHeaders = Fetch.HeadersInit.make({"Content-Type": "application/json"});

let getOpts = Fetch.RequestInit.make(~method_=Get, ~headers=jsonHeaders, ());

let postOpts = Fetch.RequestInit.make(~method_=Post, ~headers=jsonHeaders, ());

let putOpts = Fetch.RequestInit.make(~method_=Put, ~headers=jsonHeaders, ());

let deleteOpts =
  Fetch.RequestInit.make(~method_=Delete, ~headers=jsonHeaders, ());

let dataAndStatus = (response: Fetch.Response.t) : Js.Promise.t(t) =>
  Js.Promise.(
    response
    |> Fetch.Response.json
    |> then_(json =>
         {json, status: Fetch.Response.status(response)} |> resolve
       )
  );

let get = (url: string) : Js.Promise.t(t) =>
  Js.Promise.(Fetch.fetchWithInit(url, getOpts) |> then_(dataAndStatus));

let post = url =>
  Js.Promise.(Fetch.fetchWithInit(url, postOpts) |> then_(dataAndStatus));

let put = (url, body) =>
  Js.Promise.(Fetch.fetchWithInit(url, putOpts) |> then_(dataAndStatus));

let delete = (url, body) =>
  Js.Promise.(Fetch.fetchWithInit(url, deleteOpts) |> then_(dataAndStatus));

let json = (promise: Js.Promise.t(t)) : Js.Promise.t(Js.Json.t) =>
  promise |> Js.Promise.(then_(response => response.json |> resolve));
