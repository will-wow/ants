type indexed('b) = (int, 'b);

let str = ReasonReact.stringToElement;

let map_with_index = (list: list('a), f: 'a => 'b) : list(indexed('b)) =>
  list |> List.mapi((index, item: 'a) => (index, item));

let each_element =
    (list: list('a), toElement: (int, 'a) => ReasonReact.reactElement)
    : ReasonReact.reactElement =>
  list |> List.mapi(toElement) |> Array.of_list |> ReasonReact.arrayToElement;
