vim.filetype.add({
  pattern = {
    ['.*%.blade%.php'] = 'html',
    ['.*%.html%.twig'] = 'twig',
  },
})
