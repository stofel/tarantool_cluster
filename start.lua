
box.once("schema", function()
   box.schema.user.grant('guest', 'read,write,execute', 'universe')
   print('box.once executed')
end)
