type t = {
  id: int,
  title: string,
  completed: bool
};

let newItem = (id) => {
  { id: id, title: "Click a button", completed: false };
};

let toggleItem = (id, item) => {
  if ( item.id == id ) {
    {...item, completed: ! item.completed};
  } else {
    item;
  }
};