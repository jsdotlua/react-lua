-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[Store component filters should filter HOCs: 1: mount 1]=] ] = [=[

"[root]
  ▾ <Component> [Bar][Foo]
    ▾ <Component> [Foo]
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should filter HOCs: 2: hide all HOCs 1]=] ] = [=[

"[root]
  ▾ <Component> [Bar][Foo]
    ▾ <Component> [Foo]
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should filter HOCs: 3: disable HOC filter 1]=] ] = [=[

"[root]
  ▾ <Component> [Bar][Foo]
    ▾ <Component> [Foo]
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should filter by display name: 1: mount 1]=] ] = [=[

"[root]
  ▾ <Foo key=\"1\">
      <Text>
  ▾ <Bar key=\"2\">
      <Text>
  ▾ <Baz key=\"3\">
      <Text>"
]=]

exports[ [=[Store component filters should filter by display name: 2: filter "Foo" 1]=] ] = [=[

"[root]
  ▾ <Foo key=\"1\">
      <Text>
  ▾ <Bar key=\"2\">
      <Text>
  ▾ <Baz key=\"3\">
      <Text>"
]=]

exports[ [=[Store component filters should filter by display name: 3: filter "Ba" 1]=] ] = [=[

"[root]
  ▾ <Foo key=\"1\">
      <Text>
  ▾ <Bar key=\"2\">
      <Text>
  ▾ <Baz key=\"3\">
      <Text>"
]=]

exports[ [=[Store component filters should filter by display name: 4: filter "B.z" 1]=] ] = [=[

"[root]
  ▾ <Foo key=\"1\">
      <Text>
  ▾ <Bar key=\"2\">
      <Text>
  ▾ <Baz key=\"3\">
      <Text>"
]=]

exports[ [=[Store component filters should filter by path: 1: mount 1]=] ] = [=[

"[root]
  ▾ <Component>
      <TextLabel>"
]=]

exports[ [=[Store component filters should filter by path: 2: hide all components declared within this test filed 1]=] ] = [=[

"[root]
  ▾ <Component>
      <TextLabel>"
]=]

exports[ [=[Store component filters should filter by path: 3: hide components in a made up fake path 1]=] ] = [=[

"[root]
  ▾ <Component>
      <TextLabel>"
]=]

exports[ [=[Store component filters should ignore invalid ElementTypeRoot filter: 1: mount 1]=] ] = [=[

"[root]
  ▾ <Root>
      <TextLabel>"
]=]

exports[ [=[Store component filters should ignore invalid ElementTypeRoot filter: 2: add invalid filter 1]=] ] = [=[

"[root]
  ▾ <Root>
      <TextLabel>"
]=]

exports[ [=[Store component filters should support filtering by element type: 1: mount 1]=] ] = [=[

"[root]
  ▾ <Root>
    ▾ <Frame>
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should support filtering by element type: 2: hide host components 1]=] ] = [=[

"[root]
  ▾ <Root>
    ▾ <Frame>
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should support filtering by element type: 3: hide class components 1]=] ] = [=[

"[root]
  ▾ <Root>
    ▾ <Frame>
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should support filtering by element type: 4: hide class and function components 1]=] ] = [=[

"[root]
  ▾ <Root>
    ▾ <Frame>
      ▾ <Component>
          <TextLabel>"
]=]

exports[ [=[Store component filters should support filtering by element type: 5: disable all filters 1]=] ] = [=[

"[root]
  ▾ <Root>
    ▾ <Frame>
      ▾ <Component>
          <TextLabel>"
]=]

return exports
