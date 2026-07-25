<?php
/**
 * Theme setup for Post 165.
 *
 * @package Post165
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

require_once get_theme_file_path( 'inc/pure/format.php' );
require_once get_theme_file_path( 'inc/pure/meetings.php' );
require_once get_theme_file_path( 'inc/pure/overrides.php' );
require_once get_theme_file_path( 'inc/pure/year-map.php' );
require_once get_theme_file_path( 'inc/settings.php' );
require_once get_theme_file_path( 'inc/events.php' );

function post165_setup(): void {
    add_theme_support( 'wp-block-styles' );
    add_theme_support( 'editor-styles' );
    add_theme_support( 'custom-logo',
        array(
            'height'      => 96,
            'width'       => 96,
            'flex-height' => true,
            'flex-width'  => true,
        )
    );
    add_editor_style( 'style.css' );
}
add_action( 'after_setup_theme', 'post165_setup' );

function post165_enqueue_assets(): void {
    wp_enqueue_style(
        'post165-style',
        get_stylesheet_uri(),
        array(),
        wp_get_theme()->get( 'Version' )
    );
}
add_action( 'wp_enqueue_scripts', 'post165_enqueue_assets' );

function post165_register_pattern_categories(): void {
    register_block_pattern_category(
        'post165',
        array( 'label' => __( 'Post 165', 'post165' ) )
    );
}
add_action( 'init', 'post165_register_pattern_categories' );
