[
  inputs: ["*.exs", "config/*.exs"],
  subdirectories: ["apps/*"],
  locals_without_parens: [
    assert_map_match: 1,
    setup_right: 1,
    assert_right: 1,
    assert_left_error: 1,
    assert_just: 1,
    assert_nothing: 1,
    assert_map_match: 1,
    refute_map_match: 1,
    reather: 2
  ]
]
