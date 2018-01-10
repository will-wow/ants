[%bs.raw {|require('../../../styles/main.scss')|}];

[%bs.raw {|require('promise-polyfill/src/polyfill')|}];

let renderForRoute = element =>
  ReactDOMRe.renderToElementWithId(element, "root");

let router =
  DirectorRe.makeRouter({
    "/": "SimStart",
    "/sim/:id": "Sim",
    "/todo": "TodoApp"
  });

let handlers = {
  "SimStart": () => renderForRoute(<SimStartComponent router />),
  "Sim": (simId: SimId.t) => renderForRoute(<SimComponent simId />),
  "TodoApp": () => renderForRoute(<TodoAppComponent />)
};

DirectorRe.configure(
  router,
  {
    "resource": handlers,
    "notfound": () => renderForRoute(<NotFoundComponent />)
  }
);

DirectorRe.init(router, "/");

DirectorRe.configure(
  router,
  {"notfound": () => renderForRoute(<NotFoundComponent />)}
);

DirectorRe.init(router, "/");