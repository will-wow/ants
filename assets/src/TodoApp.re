let component = ReasonReact.statelessComponent("TodoApp");

let str = ReasonReact.stringToElement;

type item = {
  title: string,
  completed: bool
};

let make = _children => {
  ...component,
  render: _self =>
    <div className="app">
      <div className="title"> (str("What to do")) </div>
      <div className="items"> (str("Nothing")) </div>
    </div>
};
