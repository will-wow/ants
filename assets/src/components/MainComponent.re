[%bs.raw {|require('../../../styles/main.scss')|}];

let renderForRoute = (element) =>
  ReactDOMRe.renderToElementWithId(element, "root");

let router =
  DirectorRe.makeRouter({
    "/": () => renderForRoute(<TodoAppComponent />),
    "/sim/:id": (_simId) => renderForRoute(<TodoAppComponent />),
    "/todo": () => renderForRoute(<TodoAppComponent />)
  });

  DirectorRe.configure(router, {"notfound": () => renderForRoute(<NotFoundComponent />)});

DirectorRe.init(router, "/");