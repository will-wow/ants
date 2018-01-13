[%bs.raw {|require('../../../styles/main.scss')|}];

[%bs.raw {|require('promise-polyfill/src/polyfill')|}];

let renderForRoute = element =>
  ReactDOMRe.renderToElementWithId(element, "root");

ReasonReact.Router.watchUrl(url => {
  Js.log(url);
  (
    switch url.path {
    | [] => <SimStartComponent />
    | ["sim", simId] => <SimComponent simId=(int_of_string(simId)) />
    | ["todo"] => <TodoAppComponent />
    | _ => <NotFoundComponent />
    }
  )
  |> renderForRoute;
});

/* Hack to get router working. */
[@bs.scope ("window", "location", "pathname")] [@bs.val]
external pathname : string = "pathname";

ReasonReact.Router.push(pathname);