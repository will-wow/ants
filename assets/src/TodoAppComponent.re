let str = ReasonReact.stringToElement;

type state = {items: list(TodoItem.t)};

type action =
  | AddItem
  | ToggleItem(int);

let component = ReasonReact.reducerComponent("TodoApp");

let lastId = ref(0);

let newItem = () => {
  lastId := lastId^ + 1;
  TodoItem.newItem(lastId^)
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
    | AddItem => ReasonReact.Update({items: [newItem(), ...items]})
    | ToggleItem(id) => ReasonReact.Update({items: toggleOneItem(id, items)})
    },
  render: ({state: {items}, reduce}) => {
    let numItems = List.length(items);
    <div className="app">
      <div className="title">
        (str("What to do"))
        <button onClick=(reduce(_event => AddItem))>
          (str("Add something"))
        </button>
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