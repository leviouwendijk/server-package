import Arguments

@main
struct server_package {
    static func main() async {
        await ServerPackageApp.main(
            errorHandler: { error in
                print(
                    "error: \(error.localizedDescription)"
                )

                return 1
            }
        )
    }
}
