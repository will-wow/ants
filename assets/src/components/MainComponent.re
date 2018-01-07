[%bs.raw {|require('../../../styles/main.scss')|}];

let renderForRoute = (element) =>
  ReactDOMRe.renderToElementWithId(element, "root");

let router =
  DirectorRe.makeRouter({
    "/": () => renderForRoute(<SimStartComponent />),
    "/sim/:id": (simId) => renderForRoute(<SimComponent simId={simId}/>),
    "/todo": () => renderForRoute(<TodoAppComponent />)
  });

  DirectorRe.configure(router, {"notfound": () => renderForRoute(<NotFoundComponent />)});

DirectorRe.init(router, "/");