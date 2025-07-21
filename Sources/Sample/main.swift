import Foundation
import Plot
import Publish

struct MySite: Website {
    enum SectionID: String, WebsiteSectionID {
        case about
        case talks
        case posts

        var title: String {
            switch self {
            case .about: "About Me"
            case .talks: "Talks"
            case .posts: "Posts"
            }
        }
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    var url = URL(string: "https://www.imaizu.me/")!
    var name = "imaizume"
    var description = "About me"
    var language: Language { .japanese }
    var imagePath: Path? { nil }
}

try MySite().publish(
    withTheme: .mySite,
    deployedUsing: .gitHub("imaizume/imaizume.github.io")
)

extension Theme where Site == MySite {
    typealias S = StaticClass
    typealias D = DynamicClass

    static var mySite: Self {
        Theme(htmlFactory: MySiteHTMLFactory())
    }

    private struct MySiteHTMLFactory: HTMLFactory {
        // MARK: - Static Constants
        static let uikitBaseUrl: String = "https://cdn.jsdelivr.net/npm/uikit@3.23.11/dist"
        static let uikitCssUrl: String = "\(uikitBaseUrl)/css/uikit.min.css"
        static let uikitJsUrl: String = "\(uikitBaseUrl)/js/uikit.min.js"
        static let uikitIconsJsUrl: String = "\(uikitBaseUrl)/js/uikit-icons.min.js"

        // MARK: - Private Constants
        private let globalWidth: [Any] = [
            D.ukWidth(3, 4, nil),
            D.ukWidth(1, 2, .s),
            S.ukAlignCenter
        ]

        // MARK: - HTMLFactory Protocol Methods
        func makeIndexHTML(for index: Publish.Index, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML {
            let todayString = Date().formatted(.dateTime.year().month(.twoDigits).day(.twoDigits))
            let snsIconSize = 48
            return baseLayout(for: index.title, content: [
                .div(
                    .class(globalWidth),
                    .img(.src("./images/logo.png"), .alt("imaizume icon"), .class("uk-align-center")),
                    .h1("imaizume", .class(.ukText(.center))),
                    .p("Last Update: \(todayString)", .class(.ukText(.center))),
                    .div(
                        .class([S.ukFlex, S.ukFlexCenter]),
                        snsLinks(iconSize: snsIconSize)
                    )
                )
            ])
        }

        func makeSectionHTML(for section: Publish.Section<MySite>, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML {
            baseLayout(for: section.title, content: [
                .div(
                    .class(globalWidth),
                    .contentBody(section.body),
                    .ul(
                        .forEach(section.items) { item in
                            .li(
                                .a(.href(item.path), .text(item.title))
                            )
                        }
                    ),
                    )
            ])
        }

        func makeItemHTML(for item: Publish.Item<MySite>, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML {
            baseLayout(for: item.title, content: [.p("item")])
        }

        func makePageHTML(for page: Publish.Page, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML {
            baseLayout(for: page.title, content: [.p("page")])
        }

        func makeTagListHTML(for _: Publish.TagListPage, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML? {
            nil
        }

        func makeTagDetailsHTML(for _: Publish.TagDetailsPage, context _: Publish.PublishingContext<MySite>) throws -> Plot.HTML? {
            nil
        }

        // MARK: - Private Methods
        private func baseLayout(for _: String, content: [Node<HTML.BodyContext>]) -> HTML {
            let thisYear = Date().formatted(Date.FormatStyle().locale(Locale(identifier: "en_US")).year(.defaultDigits))
            return HTML(
                .head(
                    .link(
                        .rel(.stylesheet),
                        .href(Self.uikitCssUrl)
                    ),
                    .meta(.charset(.utf8))
                ),
                .body(
                    .nav(
                        .class(S.ukActive),
                        .attribute(named: "uk-navbar"),
                        .div(
                            .class(
                                globalWidth + [
                                    S.ukNavbarLeft
                                ]
                            ),
                            .ul(
                                .class(S.ukNavbarNav),
                                .forEach(
                                    [("Home", "/")] + MySite.SectionID.allCases.map { ( $0.title, "/\($0.rawValue)" ) }
                                ) { title, path in
                                    .li(
                                        .a(.href(path), .text(title))
                                    )
                                }
                            )
                        )
                    ),
                    .main(
                        .div(
                            .class([S.ukMarginTop, S.ukGrid]),
                            .group(content)
                        )
                    ),
                    .footer(
                        .class(
                            globalWidth + [
                                D.ukText(.center)
                            ]
                        ),
                        .p("Copyright &copy; 2010-\(thisYear) Tomohiro Imaizumi. All rights reserved.")
                    ),
                    .script(.src(Self.uikitJsUrl)),
                    .script(.src(Self.uikitIconsJsUrl))
                )
            )
        }

        private func snsLinks(iconSize: Int) -> Node<HTML.BodyContext> {
            let snsData = [
                ("https://facebook.com/imaizume/", "facebook.svg"),
                ("https://x.com/imaizume/", "x.svg"),
                ("https://www.linkedin.com/in/imaizume", "linkedin.svg"),
                ("https://imaizume.hatenablog.jp", "hatenablog.png"),
                ("https://qiita.com/imaizume/", "qiita.png"),
                ("https://zenn.dev/imaizume", "zenn.png"),
                ("https://user.retty.me/1010703/", "retty.png")
            ]

            return .group(
                snsData.map { url, iconName in
                    snsLink(url: url, iconName: iconName, iconSize: iconSize)
                }
            )
        }

        private func snsLink(url: String, iconName: String, iconSize: Int) -> Node<HTML.BodyContext> {
            .a(
                .div(
                    .class(D.ukPadding(.small)),
                    .href(url),
                    .img(
                        .attribute(named: "uk-svg", value: nil),
                        .src("./images/sns/\(iconName)"),
                        .width(iconSize),
                        .height(iconSize)
                    )
                )
            )
        }
    }
}
