struct FolkloreCommand {
  var name: String
  var aliases: [String] = []
  var handler: (FolkloreCommandContext) -> Void
}