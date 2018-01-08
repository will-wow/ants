let get = url => Js.Promise.(Fetch.fetch(url) |> then_(Fetch.Response.json));

let post = url =>
  Js.Promise.(
    Fetch.fetchWithInit(url, Fetch.RequestInit.make(~method_=Post, ()))
    |> then_(Fetch.Response.json)
  );

let put = (url, body) =>
  Js.Promise.(
    Fetch.fetchWithInit(url, Fetch.RequestInit.make(~method_=Put, ~body, ()))
    |> then_(Fetch.Response.json)
  );

let delete = (url, body) =>
  Js.Promise.(
    Fetch.fetchWithInit(
      url,
      Fetch.RequestInit.make(~method_=Delete, ~body, ())
    )
    |> then_(Fetch.Response.json)
  );