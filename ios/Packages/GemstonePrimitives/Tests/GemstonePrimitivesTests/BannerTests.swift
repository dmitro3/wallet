// Copyright (c). Gem Wallet. All rights reserved.

import struct Gemstone.GemBannerContext
import GemstonePrimitives
import Primitives
import PrimitivesTestKit
import Testing

struct BannerTests {
    @Test(arguments: [WalletType.multicoin, .single, .privateKey, .view])
    func tokenKeepsChainWarningForEveryWalletType(walletType: WalletType) {
        let wallet = Wallet.mock(type: walletType)
        let asset = Asset.mockTronUSDT()
        let warning = Banner(walletId: wallet.id, asset: .mockTron(), event: .accountBlockedMultiSignature, state: .alwaysActive)
        let stake = Banner(walletId: nil, asset: .mockTron(), event: .stake, state: .active)

        let banners = context(wallet: wallet, asset: asset).visibleBanners([stake, warning], walletId: wallet.id, asset: asset)

        #expect(banners.map(\.event) == [.accountBlockedMultiSignature])
        #expect(banners.first?.asset == .mockTron())
    }

    @Test
    func selectedBannerMapsBackToItsOwnAsset() {
        let wallet = Wallet.mock()
        let asset = Asset.mockTronUSDT()
        let native = Banner(walletId: nil, asset: .mockTron(), event: .stake, state: .active)
        let token = Banner(walletId: nil, asset: asset, event: .stake, state: .active)

        let banners = context(wallet: wallet, asset: asset).visibleBanners([native, token], walletId: wallet.id, asset: asset)

        #expect(banners.map(\.event) == [.stake])
        #expect(banners.first?.asset == asset)
    }

    private func context(wallet: Wallet, asset: Asset) -> GemBannerContext {
        GemBannerContext(
            wallet: wallet.map(),
            assetId: asset.id.identifier,
            isStakeable: true,
            hasStakeBalance: false,
            hasAvailableBalance: true,
            isAssetActivated: true,
            assetRankScore: 50,
            isWalletEmpty: false,
        )
    }
}
