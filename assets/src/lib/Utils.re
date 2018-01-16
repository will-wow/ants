type indexed('b) = (int, 'b);

type index = int;

let str = ReasonReact.stringToElement;

let map_with_index = (list: list('a), f: 'a => 'b) : list(indexed('b)) =>
  list |> List.mapi((index, item: 'a) => (index, item));

let each_element =
    (list: list('a), toElement: (index, 'a) => ReasonReact.reactElement)
    : ReasonReact.reactElement =>
  list |> List.mapi(toElement) |> Array.of_list |> ReasonReact.arrayToElement;
