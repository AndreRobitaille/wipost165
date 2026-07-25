<?php
/**
 * Title: Home What We Do
 * Slug: post165/home-what-we-do
 * Categories: post165
 * Description: The four pillars in one condensed row, plus support and contact lines.
 *
 * @package post165
 */

?>
	<!-- wp:paragraph {"className":"post165-eyebrow"} -->
	<p class="post165-eyebrow"><?php esc_html_e( 'The four pillars, locally', 'post165' ); ?></p>
	<!-- /wp:paragraph -->

	<!-- wp:columns -->
	<div class="wp-block-columns">
		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Veterans', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Helping veterans stay connected and find what they have earned.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Youth', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Programs and scholarships for young people in Two Rivers.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Remembrance', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Ceremonies and honors that keep service in public memory.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Community', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Showing up for the events and causes that hold the city together.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->
	</div>
	<!-- /wp:columns -->

	<!-- wp:separator {"className":"post165-ribbon"} -->
	<hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon" />
	<!-- /wp:separator -->

	<!-- wp:paragraph {"fontSize":"small"} -->
	<p class="has-small-font-size"><?php
		printf(
			/* translators: 1: opening link tag, 2: closing link tag */
			esc_html__( 'The post runs on volunteers and local support. %1$sWays to support Post 165%2$s.', 'post165' ),
			'<a href="' . esc_url( home_url( '/support/' ) ) . '">',
			'</a>'
		);
	?></p>
	<!-- /wp:paragraph -->

	<!-- wp:paragraph {"fontSize":"small"} -->
	<p class="has-small-font-size"><?php
		printf(
			/* translators: 1: opening link tag, 2: closing link tag */
			esc_html__( 'Questions about the post or an event? %1$sGet in touch%2$s.', 'post165' ),
			'<a href="' . esc_url( home_url( '/contact/' ) ) . '">',
			'</a>'
		);
	?></p>
	<!-- /wp:paragraph -->
