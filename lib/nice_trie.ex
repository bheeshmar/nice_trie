defmodule NiceTrie do

  @doc ~S"""
  Check for a word in the NiceTrie

  ## Examples

      iex> NiceTrie.member?([], "a")
      false

      iex> NiceTrie.member?([{"a", []}, {"be", []}], "a")
      true

      iex> NiceTrie.member?([{"a", []}, {"be", []}], "be")
      true

      iex> NiceTrie.member?([{"be", [{"er", []}, {"d", []}]}, {"a", [{"t", []}]}], "beer")
      true
      iex> NiceTrie.member?([{"be", [{"er", []}, {"d", []}]}, {"a", [{"t", []}]}], "bed")
      true
      iex> NiceTrie.member?([{"be", [{"er", []}, {"d", []}]}, {"a", [{"t", []}]}], "bet")
      false
      iex> NiceTrie.member?([{"be", [{"er", []}, {"d", []}]}, {"a", [{"t", []}]}], "bear")
      false
  """
  def member?([{prefix, suffix_trie}| tail], word) do
    if String.starts_with?(word, prefix) do
      member?(suffix_trie, String.replace(word, prefix, "", global: false))
    else
      member?(tail, word)
    end
  end
  def member?(_, ""),   do: true
  def member?([], _),   do: false
  def member?(nil, _),  do: false

  @doc ~S"""
  Store a list of words and return a NiceTrie
  """
  def store(words),     do: store(words, [])

  def store(trie, [word|words]) do
    store(words, store_word(trie, word))
  end
  def store(trie, []),  do: trie

  @doc ~S"""
  Store a word into the NiceTrie

  ## Examples

      iex> NiceTrie.store_word([], "a")
      [{"a", []}]

      iex> NiceTrie.store_word([{"a", []}], "a")
      [{"a", []}]

      iex> NiceTrie.store_word([{"a", []}], "at")
      [{"a", [{"t", []}]}]

      iex> NiceTrie.store_word([{"a", []}], "be")
      [{"be", []}, {"a", []}]

      iex> NiceTrie.store_word([{"be", []}, {"a", []}], "beer")
      [{"be", [{"er", []}]}, {"a", []}]

  """
  def store_word(trie = [{prefix,suffix_trie} | tail], word) do
    #IO.inspect {:store_word, word, prefix, suffix_trie, tail}
    if String.starts_with?(word, prefix) do
      remainder = String.replace(word, prefix, "", global: false)
      [{prefix, store_word(suffix_trie, remainder)} | tail]
    else
      [{word, []} | trie]
    end
  end
  def store_word(trie, ""), do: trie
  def store_word([], word), do: [{word, []}]
end

