let str = ReasonReact.stringToElement;

let component = ReasonReact.statelessComponent("TodoItem");
let make = (~item: TodoItem.t, ~onToggle, _children) => {
  ...component,
  render: _self =>
    <label className="item">
      <input
        _type="checkbox"
        checked=(Js.Boolean.to_js_boolean(item.completed))
        onClick=((_event) => onToggle())
      />
      (str(item.title))
    </label>
};
