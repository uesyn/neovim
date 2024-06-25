vim.filetype.add({
  pattern = {
    ['/tmp/.*%.dump'] = 'dump',
    ['/private/var/folders/.*%.dump'] = 'dump',
  },
})
