defmodule FastllmcppWeb.PromptLiveTest do
  use FastllmcppWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fastllmcpp.PromptsFixtures

  @create_attrs %{response: "some response", prompt: "some prompt"}
  @update_attrs %{response: "some updated response", prompt: "some updated prompt"}
  @invalid_attrs %{response: nil, prompt: nil}

  defp create_prompt(_) do
    prompt = prompt_fixture()
    %{prompt: prompt}
  end

  describe "Index" do
    setup [:create_prompt]

    test "lists all prompts", %{conn: conn, prompt: prompt} do
      {:ok, _index_live, html} = live(conn, ~p"/prompts")

      assert html =~ "Listing Prompts"
      assert html =~ prompt.response
    end

    test "saves new prompt", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/prompts")

      assert index_live |> element("a", "New Prompt") |> render_click() =~
               "New Prompt"

      assert_patch(index_live, ~p"/prompts/new")

      assert index_live
             |> form("#prompt-form", prompt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prompt-form", prompt: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prompts")

      html = render(index_live)
      assert html =~ "Prompt created successfully"
      assert html =~ "some response"
    end

    test "updates prompt in listing", %{conn: conn, prompt: prompt} do
      {:ok, index_live, _html} = live(conn, ~p"/prompts")

      assert index_live |> element("#prompts-#{prompt.id} a", "Edit") |> render_click() =~
               "Edit Prompt"

      assert_patch(index_live, ~p"/prompts/#{prompt}/edit")

      assert index_live
             |> form("#prompt-form", prompt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prompt-form", prompt: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prompts")

      html = render(index_live)
      assert html =~ "Prompt updated successfully"
      assert html =~ "some updated response"
    end

    test "deletes prompt in listing", %{conn: conn, prompt: prompt} do
      {:ok, index_live, _html} = live(conn, ~p"/prompts")

      assert index_live |> element("#prompts-#{prompt.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prompts-#{prompt.id}")
    end
  end

  describe "Show" do
    setup [:create_prompt]

    test "displays prompt", %{conn: conn, prompt: prompt} do
      {:ok, _show_live, html} = live(conn, ~p"/prompts/#{prompt}")

      assert html =~ "Show Prompt"
      assert html =~ prompt.response
    end

    test "updates prompt within modal", %{conn: conn, prompt: prompt} do
      {:ok, show_live, _html} = live(conn, ~p"/prompts/#{prompt}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prompt"

      assert_patch(show_live, ~p"/prompts/#{prompt}/show/edit")

      assert show_live
             |> form("#prompt-form", prompt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#prompt-form", prompt: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/prompts/#{prompt}")

      html = render(show_live)
      assert html =~ "Prompt updated successfully"
      assert html =~ "some updated response"
    end
  end
end
