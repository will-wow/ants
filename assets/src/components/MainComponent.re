[%bs.raw {|require('../../../styles/main.scss')|}];
[%bs.raw {|require('promise-polyfill/src/polyfill')|}];

let renderForRoute = element =>
  ReactDOMRe.renderToElementWithId(element, "root");

let router =
  DirectorRe.makeRouter({
    "/": () => renderForRoute(<SimStartComponent />),
    "/sim/:id": simId => renderForRoute(<SimComponent simId />),
    "/todo": () => renderForRoute(<TodoAppComponent />)
  });

DirectorRe.configure(
  router,
  {"notfound": () => renderForRoute(<NotFoundComponent />)}
);

DirectorRe.init(router, "/");

DirectorRe.configure(
  router,
  {"notfound": () => renderForRoute(<NotFoundComponent />)}
);

DirectorRe.init(router, "/");