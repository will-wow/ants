let component = ReasonReact.reducerComponent("TodoInput");

let valueFromEvent = event : string => {
  let jsValue =
    event |> ReactEventRe.Form.target |> ReactDOMRe.domElementToObj;
  jsValue##value;
};

let make = (~onSubmit, _) => {
  ...component,
  initialState: () => "",
  reducer: (newText, _text) => ReasonReact.Update(newText),
  render: ({state: text, reduce}) =>
    <input
      value=text
      _type="text"
      placeholder="Write something to do"
      onChange=(reduce(event => valueFromEvent(event)))
      onKeyDown=(
        event =>
          if (ReactEventRe.Keyboard.key(event) == "Enter") {
            onSubmit(text);
            (reduce(() => ""))();
          }
      )
    />
};