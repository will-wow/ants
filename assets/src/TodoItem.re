type t = {
  id: int,
  title: string,
  completed: bool
};

let newItem = (id: int, text: string) : t => {
  id,
  title: text,
  completed: false
};

let toggleItem = (id: int, item: t) : t =>
  if (item.id == id) {
    {...item, completed: ! item.completed};
  } else {
    item;
  };