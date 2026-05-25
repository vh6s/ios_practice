protocol DataManaging {
    func savePlace(_ item: LocationItem)
    func fetchPlaces() -> [LocationItem]
    func removePlace(_ item: LocationItem)
}
