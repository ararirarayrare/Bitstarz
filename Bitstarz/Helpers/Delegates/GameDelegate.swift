protocol GameDelegate {
    func gameOver(won: Bool)
    func collectStar()
    func configureTable(bombs: Int, stars: Int, mega: Int)
}
