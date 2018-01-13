let jsonHeaders = Fetch.HeadersInit.make({"Content-Type": "application/json"});

let getOpts = Fetch.RequestInit.make(~method_=Get, ~headers=jsonHeaders, ());

let postOpts = Fetch.RequestInit.make(~method_=Post, ~headers=jsonHeaders, ());

let putOpts = Fetch.RequestInit.make(~method_=Put, ~headers=jsonHeaders, ());

let deleteOpts =
  Fetch.RequestInit.make(~method_=Delete, ~headers=jsonHeaders, ());

let get = url =>
  Js.Promise.(Fetch.fetchWithInit(url, getOpts) |> then_(Fetch.Response.json));

let post = url =>
  Js.Promise.(
    Fetch.fetchWithInit(url, postOpts) |> then_(Fetch.Response.json)
  );

let put = (url, body) =>
  Js.Promise.(Fetch.fetchWithInit(url, putOpts) |> then_(Fetch.Response.json));

let delete = (url, body) =>
  Js.Promise.(
    Fetch.fetchWithInit(url, deleteOpts) |> then_(Fetch.Response.json)
  );