import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    @State private var posts: [Post] = SampleData.samplePosts
    @State private var showCompose: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        feedToggle
                        if viewModel.selectedTab == 0 {
                            fightFeedContent
                        } else {
                            communityContent
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color.clear)

                if viewModel.selectedTab == 1 {
                    composeButton
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showCompose) {
                ComposeSheet()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingCommentSheet) {
                if let fightId = viewModel.activeCommentFightId {
                    FeedCommentsSheet(viewModel: viewModel, fightId: fightId)
                }
            }
            .sheet(isPresented: $viewModel.showingRatingSheet) {
                if let fightId = viewModel.activeRatingFightId {
                    FeedRatingSheet(viewModel: viewModel, fightId: fightId)
                }
            }
        }
    }

    private var feedToggle: some View {
        HStack(spacing: 4) {
            ForEach(["Fights", "Community"], id: \.self) { tab in
                let index = tab == "Fights" ? 0 : 1
                Button {
                    withAnimation(.snappy) { viewModel.selectedTab = index }
                } label: {
                    Text(tab)
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(viewModel.selectedTab == index ? .white : .white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(viewModel.selectedTab == index ? Color.white.opacity(0.1) : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var fightFeedContent: some View {
        LazyVStack(spacing: 14) {
            ForEach(viewModel.allFightsWithContext, id: \.fight.id) { item in
                FeedFightCard(
                    fight: item.fight,
                    eventName: item.eventName,
                    venue: item.venue,
                    viewModel: viewModel
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, 14)
        .padding(.bottom, 100)
    }

    private var communityContent: some View {
        LazyVStack(spacing: 14) {
            ForEach(Array(posts.enumerated()), id: \.element.id) { index, _ in
                PostCard(post: binding(for: index))
            }
        }
        .padding(.horizontal)
        .padding(.top, 14)
        .padding(.bottom, 100)
    }

    private func binding(for index: Int) -> Binding<Post> {
        Binding(
            get: { posts[index] },
            set: { posts[index] = $0 }
        )
    }

    private var composeButton: some View {
        Button {
            showCompose = true
        } label: {
            Image(systemName: "square.and.pencil")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.black)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [RingsideTheme.gold, RingsideTheme.darkGold],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .clipShape(Circle())
                .shadow(color: RingsideTheme.gold.opacity(0.35), radius: 16, y: 6)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
}

struct FeedFightCard: View {
    let fight: Fight
    let eventName: String
    let venue: String
    @Bindable var viewModel: FeedViewModel

    private var interaction: FightInteraction? {
        viewModel.interactions[fight.id]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            eventHeader
            Divider().overlay(Color.white.opacity(0.06))
                .padding(.top, 10)
            matchupSection
            userRatingSection
            socialBar
        }
        .padding(16)
        .glassCard()
    }

    private var eventHeader: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 3) {
                Text(eventName)
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(RingsideTheme.gold.opacity(0.5))
                    Text(venue)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            Spacer()
            statusPill
        }
    }

    @ViewBuilder
    private var statusPill: some View {
        switch fight.status {
        case .live:
            HStack(spacing: 4) {
                LiveDot()
                Text("LIVE")
                    .font(.system(.caption2, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.liveRed)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RingsideTheme.liveRed.opacity(0.12))
            .clipShape(Capsule(style: .continuous))
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(RingsideTheme.liveRed.opacity(0.25), lineWidth: 0.5)
            )
        case .completed:
            Text("FINAL")
                .font(.system(.caption2, weight: .heavy).width(.compressed))
                .foregroundStyle(RingsideTheme.gold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(RingsideTheme.gold.opacity(0.12))
                .clipShape(Capsule(style: .continuous))
        case .upcoming:
            Text("UPCOMING")
                .font(.system(.caption2, weight: .heavy).width(.compressed))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.06))
                .clipShape(Capsule(style: .continuous))
        }
    }

    private var matchupSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 6) {
                FighterAvatar(imageURL: fight.fighterA.imageURL, size: 48)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                    .font(.system(.subheadline, weight: .heavy).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterA.record)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text("VS")
                    .font(.system(size: 16, weight: .black, design: .default).width(.compressed))
                    .tracking(3)
                    .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                Text(fight.weightClass.rawValue)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.25))
            }
            .frame(width: 60)

            VStack(spacing: 6) {
                FighterAvatar(imageURL: fight.fighterB.imageURL, size: 48)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                    .font(.system(.subheadline, weight: .heavy).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterB.record)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private var userRatingSection: some View {
        if let interaction, (interaction.userRating != nil || interaction.userComment != nil) {
            VStack(alignment: .leading, spacing: 8) {
                Divider().overlay(Color.white.opacity(0.06))

                HStack(spacing: 8) {
                    if let rating = interaction.userRating {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(RingsideTheme.gold)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundStyle(RingsideTheme.gold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(RingsideTheme.gold.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(RingsideTheme.gold.opacity(0.2), lineWidth: 0.5)
                        )
                    }

                    Spacer()

                    Button {
                        viewModel.openRating(fightId: fight.id)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil")
                                .font(.system(size: 10, weight: .semibold))
                            Text("Edit")
                                .font(.system(.caption2, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.06))
                        .clipShape(Capsule(style: .continuous))
                    }
                }

                if let comment = interaction.userComment {
                    HStack(alignment: .top, spacing: 8) {
                        Rectangle()
                            .fill(RingsideTheme.gold.opacity(0.4))
                            .frame(width: 2)
                            .clipShape(.rect(cornerRadius: 1))
                        Text(comment)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                            .lineLimit(3)
                    }
                    .padding(.leading, 4)
                }
            }
        } else {
            VStack(spacing: 0) {
                Divider().overlay(Color.white.opacity(0.06))

                Button {
                    viewModel.openRating(fightId: fight.id)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 14))
                        Text("Rate this fight")
                            .font(.system(.caption, weight: .semibold))
                    }
                    .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var socialBar: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.25)) {
                    viewModel.toggleThumbsUp(fightId: fight.id)
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: interaction?.hasThumbedUp == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 13))
                        .contentTransition(.symbolEffect(.replace))
                    Text("\(interaction?.thumbsUp ?? 0)")
                        .font(.system(.caption, weight: .semibold))
                }
                .foregroundStyle(interaction?.hasThumbedUp == true ? RingsideTheme.gold : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: interaction?.hasThumbedUp)

            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 0.5, height: 18)

            Button {
                withAnimation(.snappy(duration: 0.25)) {
                    viewModel.toggleThumbsDown(fightId: fight.id)
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: interaction?.hasThumbedDown == true ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .font(.system(size: 13))
                        .contentTransition(.symbolEffect(.replace))
                    Text("\(interaction?.thumbsDown ?? 0)")
                        .font(.system(.caption, weight: .semibold))
                }
                .foregroundStyle(interaction?.hasThumbedDown == true ? RingsideTheme.liveRed.opacity(0.8) : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: interaction?.hasThumbedDown)

            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 0.5, height: 18)

            Button {
                viewModel.openComments(fightId: fight.id)
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 13))
                    Text("\(interaction?.communityComments.count ?? 0)")
                        .font(.system(.caption, weight: .semibold))
                }
                .foregroundStyle(.white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
        }
        .padding(.top, 6)
        .overlay(alignment: .top) {
            Divider().overlay(Color.white.opacity(0.06))
        }
    }
}

struct FeedCommentsSheet: View {
    @Bindable var viewModel: FeedViewModel
    let fightId: String
    @FocusState private var isInputFocused: Bool

    private var interaction: FightInteraction? {
        viewModel.interactions[fightId]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        if let comments = interaction?.communityComments, !comments.isEmpty {
                            ForEach(comments) { comment in
                                FeedCommentRow(comment: comment)
                            }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white.opacity(0.2))
                                Text("No comments yet")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.3))
                                Text("Be the first to comment!")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.2))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(16)
                }

                Divider().overlay(Color.white.opacity(0.1))

                HStack(spacing: 10) {
                    TextField("Add a comment...", text: $viewModel.newCommentText)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.06))
                        .clipShape(.rect(cornerRadius: 20))
                        .focused($isInputFocused)

                    Button {
                        viewModel.addComment(fightId: fightId)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? Color.white.opacity(0.2)
                                    : RingsideTheme.gold
                            )
                    }
                    .disabled(viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .sensoryFeedback(.impact(flexibility: .soft), trigger: interaction?.communityComments.count)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.showingCommentSheet = false
                    }
                    .foregroundStyle(RingsideTheme.gold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationContentInteraction(.scrolls)
    }
}

struct FeedCommentRow: View {
    let comment: FightComment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(comment.avatarEmoji)
                .font(.title3)
                .frame(width: 32, height: 32)
                .background(Color.white.opacity(0.06))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(comment.userName)
                        .font(.system(.caption, weight: .bold))
                        .foregroundStyle(comment.userName == "You" ? RingsideTheme.gold : .white.opacity(0.7))
                    Text(comment.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.3))
                }
                Text(comment.text)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
}

struct FeedRatingSheet: View {
    @Bindable var viewModel: FeedViewModel
    let fightId: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", viewModel.ratingDraft))
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundStyle(ratingColor)
                    Text("YOUR RATING")
                        .font(.system(.caption, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white.opacity(0.4))
                }

                VStack(spacing: 8) {
                    Slider(value: $viewModel.ratingDraft, in: 1...10, step: 0.5)
                        .tint(ratingColor)
                    HStack {
                        Text("1")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.3))
                        Spacer()
                        Text("10")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("COMMENT (OPTIONAL)")
                        .font(.system(.caption2, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white.opacity(0.35))
                    TextField("What did you think?", text: $viewModel.ratingCommentDraft, axis: .vertical)
                        .font(.subheadline)
                        .lineLimit(3...5)
                        .padding(12)
                        .background(Color.white.opacity(0.06))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button {
                    viewModel.submitRating(fightId: fightId)
                    viewModel.showingRatingSheet = false
                } label: {
                    Text("Submit Rating")
                        .font(.system(.headline, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RingsideTheme.gold)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .sensoryFeedback(.success, trigger: false)

                Spacer()
            }
            .padding(24)
            .navigationTitle("Rate Fight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        viewModel.showingRatingSheet = false
                    }
                    .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private var ratingColor: Color {
        if viewModel.ratingDraft >= 8 { return RingsideTheme.gold }
        if viewModel.ratingDraft >= 5 { return .white }
        return RingsideTheme.liveRed.opacity(0.8)
    }
}

struct PostCard: View {
    @Binding var post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(post.avatarEmoji)
                    .font(.title2)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
                    .overlay(
                        Circle().strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                    )

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(post.userName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        ForEach(post.badges, id: \.self) { badge in
                            Text(badge)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(RingsideTheme.gold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(RingsideTheme.gold.opacity(0.12))
                                .clipShape(Capsule(style: .continuous))
                        }
                    }
                    Text(post.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.35))
                }
                Spacer()
            }

            if let context = post.fightContext {
                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 10))
                    Text(context)
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(RingsideTheme.gold.opacity(0.08))
                .clipShape(Capsule(style: .continuous))
            }

            Text(post.text)
                .font(.body)
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(4)

            HStack(spacing: 24) {
                Button {
                    withAnimation(.snappy) {
                        post.isLiked.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(post.isLiked ? RingsideTheme.liveRed : .white.opacity(0.4))
                            .contentTransition(.symbolEffect(.replace))
                        Text("\(post.likes + (post.isLiked ? 1 : 0))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
                .sensoryFeedback(.impact(flexibility: .soft), trigger: post.isLiked)

                HStack(spacing: 4) {
                    Image(systemName: "bubble.right")
                        .foregroundStyle(.white.opacity(0.4))
                    Text("\(post.comments)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }

                Spacer()

                Image(systemName: "square.and.arrow.up")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .font(.subheadline)
        }
        .padding(16)
        .glassCard()
    }
}

struct ComposeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    Text("🥊")
                        .font(.title2)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.06))
                        .clipShape(Circle())

                    TextField("What's on your mind?", text: $text, axis: .vertical)
                        .font(.body)
                        .lineLimit(6...12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(RingsideTheme.gold)
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
