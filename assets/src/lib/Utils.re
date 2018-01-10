let str = ReasonReact.stringToElement;

let each_element =
    (list: list('a), toElement: 'a => ReasonReact.reactElement)
    : ReasonReact.reactElement =>
  list |> List.map(toElement) |> Array.of_list |> ReasonReact.arrayToElement;