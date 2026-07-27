import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: VerseViewModel
    @State private var isCreatingFolder = false
    @State private var newFolderName = ""
    @State private var verseToOrganise: ScriptureVerse?

    var body: some View {
        Group {
            if viewModel.likedVerses.isEmpty {
                emptyState
            } else {
                savedContent
            }
        }
        .navigationTitle("Saved Verses")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .toolbar {
            if !viewModel.likedVerses.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        newFolderName = ""
                        isCreatingFolder = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                    .accessibilityLabel("New folder")
                }
            }
        }
        .alert("New Folder", isPresented: $isCreatingFolder) {
            TextField("Folder name", text: $newFolderName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                viewModel.createFolder(named: newFolderName)
            }
        } message: {
            Text("Create a folder to organise your saved verses.")
        }
        .sheet(item: $verseToOrganise) { verse in
            FolderPickerSheet(viewModel: viewModel, verse: verse)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "heart")
                .font(.system(size: 28))
                .foregroundColor(.secondary)

            Text("No Saved Verses")
                .font(.system(size: 22, weight: .semibold))

            Text("Save a verse from the home page and it will appear here.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)

            Spacer()
        }
        .padding(24)
    }

    private var savedContent: some View {
        List {
            Section {
                NavigationLink {
                    SavedVerseListView(
                        title: "All Saved",
                        verses: viewModel.likedVerses,
                        viewModel: viewModel
                    )
                } label: {
                    folderRow(
                        name: "All Saved",
                        count: viewModel.likedVerses.count,
                        systemImage: "heart.fill"
                    )
                }

                ForEach(viewModel.verseFolders) { folder in
                    NavigationLink {
                        FolderDetailView(folderID: folder.id, viewModel: viewModel)
                    } label: {
                        folderRow(
                            name: folder.name,
                            count: viewModel.verses(in: folder).count,
                            systemImage: "folder.fill"
                        )
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.deleteFolder(folder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            } header: {
                Text("Folders")
            }

            Section("Recently Saved") {
                ForEach(viewModel.likedVerses) { verse in
                    verseRow(verse)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private func folderRow(name: String, count: Int, systemImage: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 28)

            Text(name)
                .font(.system(size: 16, weight: .medium))

            Spacer()

            Text("\(count)")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }

    private func verseRow(_ verse: ScriptureVerse) -> some View {
        NavigationLink {
            VerseDetailView(verse: verse)
        } label: {
            CompactVerseCard(verse: verse)
        }
        .listRowSeparator(.hidden)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                verseToOrganise = verse
            } label: {
                Label("Organise", systemImage: "folder")
            }
            .tint(.blue)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.unlike(verse)
            } label: {
                Label("Unsave", systemImage: "heart.slash")
            }
        }
        .contextMenu {
            Button {
                verseToOrganise = verse
            } label: {
                Label("Add to Folder", systemImage: "folder")
            }
        }
    }
}

private struct FolderDetailView: View {
    let folderID: UUID
    @ObservedObject var viewModel: VerseViewModel
    @State private var verseToOrganise: ScriptureVerse?

    private var folder: VerseFolder? {
        viewModel.verseFolders.first { $0.id == folderID }
    }

    var body: some View {
        Group {
            if let folder, viewModel.verses(in: folder).isEmpty {
                ContentUnavailableView(
                    "Folder Is Empty",
                    systemImage: "folder",
                    description: Text("Add verses from the Saved Verses screen.")
                )
            } else if let folder {
                SavedVerseListView(
                    title: folder.name,
                    verses: viewModel.verses(in: folder),
                    viewModel: viewModel,
                    onOrganise: { verseToOrganise = $0 }
                )
            }
        }
        .navigationTitle(folder?.name ?? "Folder")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $verseToOrganise) { verse in
            FolderPickerSheet(viewModel: viewModel, verse: verse)
        }
    }
}

private struct SavedVerseListView: View {
    let title: String
    let verses: [ScriptureVerse]
    @ObservedObject var viewModel: VerseViewModel
    var onOrganise: ((ScriptureVerse) -> Void)?
    @State private var verseToOrganise: ScriptureVerse?

    var body: some View {
        List(verses) { verse in
            NavigationLink {
                VerseDetailView(verse: verse)
            } label: {
                CompactVerseCard(verse: verse)
            }
            .listRowSeparator(.hidden)
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button {
                    if let onOrganise {
                        onOrganise(verse)
                    } else {
                        verseToOrganise = verse
                    }
                } label: {
                    Label("Organise", systemImage: "folder")
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.unlike(verse)
                } label: {
                    Label("Unsave", systemImage: "heart.slash")
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $verseToOrganise) { verse in
            FolderPickerSheet(viewModel: viewModel, verse: verse)
        }
    }
}

private struct FolderPickerSheet: View {
    @ObservedObject var viewModel: VerseViewModel
    let verse: ScriptureVerse
    @Environment(\.dismiss) private var dismiss
    @State private var isCreatingFolder = false
    @State private var newFolderName = ""

    var body: some View {
        NavigationStack {
            List {
                if viewModel.verseFolders.isEmpty {
                    ContentUnavailableView(
                        "No Folders",
                        systemImage: "folder",
                        description: Text("Create a folder to organise this verse.")
                    )
                } else {
                    ForEach(viewModel.verseFolders) { folder in
                        Button {
                            let isIncluded = viewModel.isVerse(verse, in: folder)
                            viewModel.setVerse(verse, in: folder, isIncluded: !isIncluded)
                        } label: {
                            HStack {
                                Image(systemName: "folder")
                                Text(folder.name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if viewModel.isVerse(verse, in: folder) {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add to Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("New Folder") {
                        newFolderName = ""
                        isCreatingFolder = true
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("New Folder", isPresented: $isCreatingFolder) {
                TextField("Folder name", text: $newFolderName)
                Button("Cancel", role: .cancel) {}
                Button("Create") {
                    viewModel.createFolder(named: newFolderName)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView(viewModel: VerseViewModel())
    }
}
