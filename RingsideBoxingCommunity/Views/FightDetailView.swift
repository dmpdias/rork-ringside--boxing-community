import SwiftUI

struct FightDetailView: View {
    let fight: Fight
    @State private var vm: FightDetailViewModel

    init(fight: Fight) {
        self.fight = fight
        self._vm = State(wrappedValue: FightDetailViewModel(fight: fight))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroHeader
                fighterInfoCard
                liveResultBlock
                    .padding(.top, 12)
                overallRatingBlock
                    .padding(.top, 16)
                roundByRoundStrip
                    .padding(.top, 16)
                actionsRow
                    .padding(.top, 14)
                discussionCarousel
                    .padding(.top, 20)
            }
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(MeshBackgroundView())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .sheet(isPresented: $vm.showRoundRatingSheet) {
            roundRatingSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $vm.showPredictionSheet) {
            predictionSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $vm.showDiscussionModal) {
            discussionModal
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        VStack(spacing: 0) {
            Text(eventNameForFight.uppercased())
                .font(.system(size: 22, weight: .heavy, design: .default).width(.compressed))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 4)

            Text(eventSubtitle)
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
                .padding(.top, 2)

            HStack(alignment: .bottom, spacing: 0) {
                fighterPhoto(fighter: fight.fighterA, alignment: .leading)

                VStack(spacing: 6) {
                    if fight.status == .live {
                        HStack(spacing: 5) {
                            LiveDot()
                            Text("RD \(fight.currentRound ?? 1)/\(fight.scheduledRounds)")
                                .font(.system(.caption2, weight: .bold).width(.compressed))
                                .foregroundStyle(RingsideTheme.liveRed)
                        }
                    }

                    Text("VS")
                        .font(.system(size: 36, weight: .black, design: .default).width(.compressed))
                        .foregroundStyle(RingsideTheme.gold)
                        .tracking(4)

                    statusLabel
                }
                .frame(width: 80)
                .padding(.bottom, 40)

                fighterPhoto(fighter: fight.fighterB, alignment: .trailing)
            }
            .padding(.top, 8)
        }
    }

    private func fighterPhoto(fighter: Fighter, alignment: HorizontalAlignment) -> some View {
        VStack(spacing: 0) {
            if let urlString = fighter.imageURL, let url = URL(string: urlString) {
                Color.clear
                    .frame(height: 220)
                    .overlay {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                fighterPlaceholder
                            case .empty:
                                ProgressView().tint(.white.opacity(0.3))
                            @unknown default:
                                fighterPlaceholder
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .clear, Color(red: 0.04, green: 0.04, blue: 0.07).opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(.rect(cornerRadius: 16))
                    )
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 2) {
                            Text(fighter.country)
                                .font(.title3)
                            Text(fighter.name.components(separatedBy: " ").last ?? "")
                                .font(.system(.subheadline, weight: .heavy).width(.compressed))
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 8)
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(height: 220)
                    VStack(spacing: 8) {
                        Image(systemName: "figure.boxing")
                            .font(.system(size: 64))
                            .foregroundStyle(.white.opacity(0.15))
                        Text(fighter.country)
                            .font(.title3)
                        Text(fighter.name.components(separatedBy: " ").last ?? "")
                            .font(.system(.subheadline, weight: .heavy).width(.compressed))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var fighterPlaceholder: some View {
        ZStack {
            Color.white.opacity(0.04)
            Image(systemName: "figure.boxing")
                .font(.system(size: 54))
                .foregroundStyle(.white.opacity(0.12))
        }
    }

    @ViewBuilder
    private var statusLabel: some View {
        switch fight.status {
        case .live:
            Text("LIVE")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.liveRed)
        case .upcoming:
            Text(fight.date?.formatted(.dateTime.month(.abbreviated).day()) ?? "TBD")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(.white.opacity(0.4))
        case .completed:
            Text("FINAL")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.gold)
        }
    }

    // MARK: - Fighter Info Card

    private var fighterInfoCard: some View {
        HStack {
            VStack(spacing: 2) {
                Text(fight.fighterA.name)
                    .font(.system(.subheadline, weight: .bold).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterA.record)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
                if !fight.fighterA.nickname.isEmpty {
                    Text("\"\(fight.fighterA.nickname)\"")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 2) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption2, weight: .bold).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                Text("\(fight.scheduledRounds) ROUNDS")
                    .font(.system(.caption2, weight: .semibold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.3))
            }

            VStack(spacing: 2) {
                Text(fight.fighterB.name)
                    .font(.system(.subheadline, weight: .bold).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterB.record)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
                if !fight.fighterB.nickname.isEmpty {
                    Text("\"\(fight.fighterB.nickname)\"")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.white.opacity(0.04)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 0.5
                )
        )
        .padding(.horizontal, 16)
    }

    // MARK: - 1. Live Result Block

    private var liveResultBlock: some View {
        VStack(spacing: 10) {
            switch vm.phase {
            case .pre:
                preResultContent
            case .live:
                liveResultContent
            case .post:
                postResultContent
            }
        }
        .padding(16)
        .glassCard()
        .padding(.horizontal, 16)
    }

    private var preResultContent: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                if let countdown = vm.countdownText {
                    Text(countdown)
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                }
                Text("·")
                    .foregroundStyle(.white.opacity(0.3))
                Text("\(fight.scheduledRounds) rounds")
                    .font(.system(.subheadline, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                if fight.isTitleFight {
                    Text("·")
                        .foregroundStyle(.white.opacity(0.3))
                    Text("Title fight")
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(RingsideTheme.gold)
                }
            }

            if vm.hasPredicted {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text("Prediction: \(vm.predictedWinner ?? "") · \(vm.predictedMethod?.rawValue ?? "") · Rds \(vm.predictedRoundRange ?? "")")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.green.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            } else {
                Button {
                    vm.showPredictionSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chart.bar.fill")
                            .font(.caption)
                        Text("PREDICT")
                            .font(.system(.caption, weight: .bold).width(.compressed))
                    }
                    .foregroundStyle(RingsideTheme.gold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                    .background(RingsideTheme.gold.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(RingsideTheme.gold.opacity(0.25), lineWidth: 0.5)
                    )
                }
            }
        }
    }

    private var liveResultContent: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                LiveDot()
                Text("RD \(fight.currentRound ?? 1) / \(fight.scheduledRounds)")
                    .font(.system(.title3, weight: .heavy).width(.compressed))
                    .foregroundStyle(.white)
                Text("· Live")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(RingsideTheme.liveRed)
            }

            if let score = vm.unofficialScore {
                Text("Unofficial: \(score)")
                    .font(.system(.caption, weight: .medium).italic())
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    private var postResultContent: some View {
        VStack(spacing: 6) {
            if let result = fight.result {
                Text("FINAL RESULT")
                    .font(.system(.caption2, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))

                Text(result.method)
                    .font(.system(.title3, weight: .heavy))
                    .foregroundStyle(.white)

                if let scores = result.scores {
                    Text(scores)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }

                if let winner = result.winnerName {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundStyle(RingsideTheme.gold)
                        Text("Winner: \(winner)")
                            .font(.system(.subheadline, weight: .bold))
                            .foregroundStyle(RingsideTheme.gold)
                    }
                    .padding(.top, 2)
                }
            } else {
                Text("FINAL")
                    .font(.system(.title3, weight: .heavy))
                    .foregroundStyle(RingsideTheme.gold)
            }
        }
    }

    // MARK: - 2. Overall Rating Block

    private var overallRatingBlock: some View {
        VStack(spacing: 14) {
            HStack {
                Text("YOUR RATING")
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))
                Spacer()
                if vm.phase == .live && !vm.hasRatedOverall {
                    Text("Set after the final bell")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(.white.opacity(0.25))
                }
            }

            ratingNumberDisplay

            tagChips

            if vm.hasRatedOverall {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("Rated \(String(format: "%.1f", vm.overallRating))/10")
                        .font(.caption)
                        .foregroundStyle(.green.opacity(0.8))
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .padding(16)
        .glassGoldCard()
        .opacity(vm.phase == .live ? 0.7 : 1.0)
        .padding(.horizontal, 16)
    }

    private var ratingNumberDisplay: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach([2.0, 4.0, 6.0, 8.0, 10.0], id: \.self) { value in
                    Button {
                        withAnimation(.bouncy) {
                            vm.overallRating = vm.overallRating == value ? 0 : value
                        }
                    } label: {
                        Text(String(format: "%.0f", value))
                            .font(.system(.title3, weight: .heavy))
                            .foregroundStyle(vm.overallRating >= value ? RingsideTheme.gold : .white.opacity(0.15))
                            .frame(width: 48, height: 48)
                            .background(
                                vm.overallRating >= value
                                    ? RingsideTheme.gold.opacity(0.15)
                                    : Color.white.opacity(0.04)
                            )
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .strokeBorder(
                                        vm.overallRating >= value
                                            ? RingsideTheme.gold.opacity(0.4)
                                            : Color.white.opacity(0.06),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .sensoryFeedback(.impact(weight: .light), trigger: vm.overallRating)
                }
            }

            Slider(value: $vm.overallRating, in: 0...10, step: 0.1)
                .tint(RingsideTheme.gold)
                .padding(.horizontal, 4)

            if vm.overallRating > 0 {
                Text(String(format: "%.1f", vm.overallRating))
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(RingsideTheme.gold)
                    .contentTransition(.numericText())
            }
        }
    }

    private var tagChips: some View {
        HStack(spacing: 8) {
            ForEach(FightTag.allCases, id: \.rawValue) { tag in
                Button {
                    withAnimation(.snappy) {
                        if vm.selectedTags.contains(tag) {
                            vm.selectedTags.remove(tag)
                        } else {
                            vm.selectedTags.insert(tag)
                        }
                    }
                } label: {
                    Text(tag.rawValue)
                        .font(.system(.caption2, weight: .bold))
                        .foregroundStyle(vm.selectedTags.contains(tag) ? .black : .white.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            vm.selectedTags.contains(tag)
                                ? RingsideTheme.gold
                                : Color.white.opacity(0.06)
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - 3. Round-by-Round Strip

    private var roundByRoundStrip: some View {
        VStack(spacing: 10) {
            HStack {
                Text("ROUND-BY-ROUND")
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))
                Spacer()
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(1...fight.scheduledRounds, id: \.self) { round in
                        let tappable = vm.isRoundTappable(round)
                        let hasRating = vm.roundRatings[round] != nil
                        let score = vm.roundRatings[round]?.score

                        Button {
                            guard tappable else { return }
                            vm.openRoundRating(round)
                        } label: {
                            VStack(spacing: 4) {
                                Text("R\(round)")
                                    .font(.system(.caption2, weight: .bold))
                                    .foregroundStyle(tappable ? .white : .white.opacity(0.2))

                                if let s = score {
                                    Text(String(format: "%.0f", s))
                                        .font(.system(.caption, weight: .heavy))
                                        .foregroundStyle(RingsideTheme.gold)
                                } else {
                                    Text("–")
                                        .font(.system(.caption, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.15))
                                }

                                if hasRating {
                                    Circle()
                                        .fill(RingsideTheme.gold)
                                        .frame(width: 4, height: 4)
                                } else if tappable {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.white.opacity(0.25))
                                }
                            }
                            .frame(width: 44, height: 60)
                            .background(
                                hasRating
                                    ? RingsideTheme.gold.opacity(0.1)
                                    : Color.white.opacity(tappable ? 0.04 : 0.02)
                            )
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .strokeBorder(
                                        hasRating
                                            ? RingsideTheme.gold.opacity(0.3)
                                            : Color.white.opacity(0.06),
                                        lineWidth: 0.5
                                    )
                            )
                        }
                        .disabled(!tappable)
                    }
                }
                .padding(.horizontal, 16)
            }
            .contentMargins(.horizontal, 0)

            Button {
                if vm.scoredRoundCount > 0 {
                    let nextUnscoredRound = (1...fight.scheduledRounds).first { vm.roundRatings[$0] == nil && vm.isRoundTappable($0) }
                    if let round = nextUnscoredRound {
                        vm.openRoundRating(round)
                    }
                }
            } label: {
                Text(vm.cardButtonLabel.uppercased())
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(vm.canSaveCard ? .black : RingsideTheme.gold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(vm.canSaveCard ? RingsideTheme.gold : RingsideTheme.gold.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 10))
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - 4. Actions Row

    private var actionsRow: some View {
        HStack(spacing: 10) {
            Button {
                withAnimation(.bouncy) { vm.isFavorite.toggle() }
            } label: {
                Image(systemName: vm.isFavorite ? "star.fill" : "star")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(vm.isFavorite ? RingsideTheme.gold : .white.opacity(0.5))
                    .frame(width: 44, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(
                                vm.isFavorite ? RingsideTheme.gold.opacity(0.3) : Color.white.opacity(0.08),
                                lineWidth: 0.5
                            )
                    )
            }
            .sensoryFeedback(.impact(weight: .medium), trigger: vm.isFavorite)

            Button { } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 44, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
            }

            Button {
                withAnimation(.bouncy) { vm.isAddedToLog.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: vm.isAddedToLog ? "checkmark" : "plus")
                        .font(.caption)
                    Text(vm.isAddedToLog ? "IN LOG" : "ADD TO LOG")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                }
                .foregroundStyle(vm.isAddedToLog ? .black : .white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(vm.isAddedToLog ? RingsideTheme.gold : Color.white.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            vm.isAddedToLog ? RingsideTheme.gold.opacity(0.4) : Color.white.opacity(0.08),
                            lineWidth: 0.5
                        )
                )
            }
            .sensoryFeedback(.impact(weight: .light), trigger: vm.isAddedToLog)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 5. Discussion Carousel

    private var discussionCarousel: some View {
        VStack(spacing: 10) {
            HStack {
                Text(vm.carouselLabel)
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))
                Spacer()
                Button {
                    vm.showDiscussionModal = true
                } label: {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.system(.caption2, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)

            if !vm.carouselComments.isEmpty {
                TabView(selection: $vm.carouselIndex) {
                    ForEach(Array(vm.carouselComments.enumerated()), id: \.element.id) { index, comment in
                        discussionCarouselCard(comment)
                            .tag(index)
                            .padding(.horizontal, 16)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 130)
                .onAppear { startCarouselTimer() }
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { _ in vm.carouselPaused = true }
                        .onEnded { _ in
                            Task {
                                try? await Task.sleep(for: .seconds(4))
                                vm.carouselPaused = false
                            }
                        }
                )
            }
        }
    }

    private func discussionCarouselCard(_ comment: DiscussionComment) -> some View {
        Button {
            vm.showDiscussionModal = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(comment.userName)
                        .font(.system(.caption, weight: .bold))
                        .foregroundStyle(RingsideTheme.gold)
                    Spacer()
                    Text(comment.timestamp, format: .dateTime.hour().minute())
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.25))
                }

                Text(comment.text)
                    .font(.system(.subheadline, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup")
                            .font(.system(size: 10))
                        Text("\(comment.thumbsUp)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.35))

                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsdown")
                            .font(.system(size: 10))
                        Text("\(comment.thumbsDown)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.35))

                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.system(size: 10))
                        Text("Reply")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.35))
                }
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
            )
        }
    }

    private func startCarouselTimer() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                guard !vm.carouselPaused, !vm.carouselComments.isEmpty else { continue }
                withAnimation(.easeInOut(duration: 0.4)) {
                    vm.carouselIndex = (vm.carouselIndex + 1) % vm.carouselComments.count
                }
            }
        }
    }

    // MARK: - Round Rating Sheet

    private var roundRatingSheet: some View {
        VStack(spacing: 20) {
            Text("ROUND \(vm.activeRoundForRating)")
                .font(.system(.title2, weight: .black).width(.compressed))
                .foregroundStyle(.primary)

            VStack(spacing: 8) {
                Text(String(format: "%.1f", vm.roundRatingDraft))
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(RingsideTheme.gold)
                    .contentTransition(.numericText())

                Slider(value: $vm.roundRatingDraft, in: 0...10, step: 0.5)
                    .tint(RingsideTheme.gold)
            }

            HStack(spacing: 8) {
                ForEach(RoundTag.allCases, id: \.rawValue) { tag in
                    Button {
                        withAnimation(.snappy) {
                            if vm.roundTagsDraft.contains(tag) {
                                vm.roundTagsDraft.remove(tag)
                            } else {
                                vm.roundTagsDraft.insert(tag)
                            }
                        }
                    } label: {
                        Text(tag.rawValue)
                            .font(.system(.caption, weight: .bold))
                            .foregroundStyle(vm.roundTagsDraft.contains(tag) ? .black : .secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                vm.roundTagsDraft.contains(tag)
                                    ? RingsideTheme.gold
                                    : Color(.tertiarySystemFill)
                            )
                            .clipShape(Capsule())
                    }
                }
            }

            Button {
                vm.saveRoundRating()
            } label: {
                Text("Save Round Score")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RingsideTheme.gold)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(24)
    }

    // MARK: - Prediction Sheet

    private var predictionSheet: some View {
        VStack(spacing: 20) {
            Text("YOUR PREDICTION")
                .font(.system(.title2, weight: .black).width(.compressed))
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 12) {
                Text("Winner")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)

                Picker("Winner", selection: $vm.predictionWinnerDraft) {
                    Text(fight.fighterA.name).tag(fight.fighterA.name)
                    Text(fight.fighterB.name).tag(fight.fighterB.name)
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Method")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)

                Picker("Method", selection: $vm.predictionMethodDraft) {
                    ForEach(PredictionMethod.allCases, id: \.rawValue) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Round Range")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)

                Picker("Rounds", selection: $vm.predictionRoundDraft) {
                    Text("1–3").tag("1-3")
                    Text("4–6").tag("4-6")
                    Text("7–9").tag("7-9")
                    Text("10–12").tag("10-12")
                }
                .pickerStyle(.segmented)
            }

            Button {
                vm.submitPrediction()
            } label: {
                Text("Lock In Prediction")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RingsideTheme.gold)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(24)
    }

    // MARK: - 6. Discussion Modal

    private var discussionModal: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    TextField("Share your take...", text: $vm.newCommentText)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Capsule())

                    Button {
                        vm.addComment()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(vm.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.secondary : RingsideTheme.gold)
                    }
                    .disabled(vm.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                Picker("Sort", selection: $vm.discussionTab) {
                    ForEach(DiscussionTab.allCases, id: \.rawValue) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.visibleDiscussion) { comment in
                            discussionCommentRow(comment)
                            Divider()
                                .overlay(Color.white.opacity(0.04))
                        }

                        if vm.canLoadMore {
                            Button {
                                vm.loadMoreComments()
                            } label: {
                                Text("Load more comments")
                                    .font(.system(.subheadline, weight: .semibold))
                                    .foregroundStyle(RingsideTheme.gold)
                                    .padding(.vertical, 16)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Match Discussion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        vm.showDiscussionModal = false
                    }
                    .foregroundStyle(RingsideTheme.gold)
                }
            }
        }
    }

    private func discussionCommentRow(_ comment: DiscussionComment) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.userName)
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(.primary)
                if comment.isPrediction {
                    Text("PREDICTION")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(RingsideTheme.gold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(RingsideTheme.gold.opacity(0.15))
                        .clipShape(Capsule())
                }
                Spacer()
                Text(comment.timestamp, format: .dateTime.hour().minute())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text(comment.text)
                .font(.subheadline)
                .foregroundStyle(.primary.opacity(0.9))

            HStack(spacing: 20) {
                Button {
                    vm.toggleDiscussionThumbsUp(comment.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: comment.hasThumbedUp ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.caption)
                        Text("\(comment.thumbsUp)")
                            .font(.caption)
                    }
                    .foregroundStyle(comment.hasThumbedUp ? RingsideTheme.gold : .secondary)
                }

                Button {
                    vm.toggleDiscussionThumbsDown(comment.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: comment.hasThumbedDown ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .font(.caption)
                        Text("\(comment.thumbsDown)")
                            .font(.caption)
                    }
                    .foregroundStyle(comment.hasThumbedDown ? RingsideTheme.liveRed : .secondary)
                }

                Button { } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.caption)
                        Text("Reply")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Helpers

    private var eventNameForFight: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.name
            }
        }
        return "RINGSIDE EVENT"
    }

    private var eventSubtitle: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.venue
            }
        }
        return ""
    }
}

extension Fight {
    var date: Date? {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == self.id }) {
                return event.date
            }
        }
        return nil
    }
}
