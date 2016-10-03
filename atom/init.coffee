# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"


# Display random face for error-message in command palette.
# Randomized on each command-palette toggle
atom.commands.onDidDispatch (event) ->
  if event.type is "command-palette:toggle"
    workspaceElement = atom.views.getView(atom.workspace)
    errorMessage = workspaceElement.querySelector(".command-palette .error-message")
    errorMessage.classList
      .remove("face-1", "face-2", "face-3", "face-4", "face-5", "face-6", "face-7", "face-8", "face-9", "face-10", "face-11", "face-12", "face-13")
    errorMessage.classList
      .add("face-#{Math.floor(Math.random() * (13 - 1) + 1)}")
