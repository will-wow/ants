let renderForRoute = element =>
  ReactDOMRe.renderToElementWithId(element, "root");

ReasonReact.Router.watchUrl(url =>
  (
    switch url.path {
    | [] => <SimStartComponent />
    | ["sim", simId] => <SimComponent simId=(int_of_string(simId)) />
    | _ => <NotFoundComponent />
    }
  )
  |> renderForRoute
);

/* Hack to get router working. */
[@bs.scope ("window", "location", "pathname")] [@bs.val]
external pathname : string = "pathname";

ReasonReact.Router.push(pathname);
