defmodule Fastllmcpp.PromptsTest do
  use Fastllmcpp.DataCase

  alias Fastllmcpp.Prompts

  describe "prompts" do
    alias Fastllmcpp.Prompts.Prompt

    import Fastllmcpp.PromptsFixtures

    @invalid_attrs %{response: nil, prompt: nil}

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Prompts.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Prompts.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      valid_attrs = %{response: "some response", prompt: "some prompt"}

      assert {:ok, %Prompt{} = prompt} = Prompts.create_prompt(valid_attrs)
      assert prompt.response == "some response"
      assert prompt.prompt == "some prompt"
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_prompt(@invalid_attrs)
    end

    test "update_prompt/2 with valid data updates the prompt" do
      prompt = prompt_fixture()
      update_attrs = %{response: "some updated response", prompt: "some updated prompt"}

      assert {:ok, %Prompt{} = prompt} = Prompts.update_prompt(prompt, update_attrs)
      assert prompt.response == "some updated response"
      assert prompt.prompt == "some updated prompt"
    end

    test "update_prompt/2 with invalid data returns error changeset" do
      prompt = prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.update_prompt(prompt, @invalid_attrs)
      assert prompt == Prompts.get_prompt!(prompt.id)
    end

    test "delete_prompt/1 deletes the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{}} = Prompts.delete_prompt(prompt)
      assert_raise Ecto.NoResultsError, fn -> Prompts.get_prompt!(prompt.id) end
    end

    test "change_prompt/1 returns a prompt changeset" do
      prompt = prompt_fixture()
      assert %Ecto.Changeset{} = Prompts.change_prompt(prompt)
    end
  end
end
