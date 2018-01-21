defmodule AntsWeb.AppControllerTest do
  use AntsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Ants"
  end
end
