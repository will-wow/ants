let str = ReasonReact.stringToElement;

type state = {items: list(TodoItem.t)};

type action =
  | AddItem(string)
  | ToggleItem(int);

let component = ReasonReact.reducerComponent("TodoApp");

let lastId = ref(0);

let newItem = (text: string) : TodoItem.t => {
  lastId := lastId^ + 1;
  TodoItem.newItem(lastId^, text);
};

let toggleOneItem = (id, items) => {
  List.map(TodoItem.toggleItem(id), items);
};

let make = _children => {
  ...component,
  initialState: () => {
    items: []
  },
  reducer: (action, {items}) =>
    switch action {
    | AddItem(text) => ReasonReact.Update({items: [newItem(text), ...items]})
    | ToggleItem(id) => ReasonReact.Update({items: toggleOneItem(id, items)})
    },
  render: ({state: {items}, reduce}) => {
    let numItems = List.length(items);
    <div className="app">
      <div className="title">
        (str("What to do"))
        <TodoInputComponent onSubmit=(reduce(text => AddItem(text))) />
      </div>
      <div className="items">
        (
          items
          |> List.map(item => <TodoItemComponent key=(string_of_int((item : TodoItem.t).id )) onToggle=(reduce(() => ToggleItem(item.id))) item />)
          |> Array.of_list
          |> ReasonReact.arrayToElement
        )
      </div>
      <div className="footer">
        (str(string_of_int(numItems) ++ " items"))
      </div>
    </div>;
  }
};