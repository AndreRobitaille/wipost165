<?php
/**
 * Theme setup for Post 165.
 *
 * @package Post165
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

function post165_setup(): void {
    add_theme_support( 'wp-block-styles' );
    add_theme_support( 'editor-styles' );
    add_editor_style( 'style.css' );
}
add_action( 'after_setup_theme', 'post165_setup' );

function post165_register_pattern_categories(): void {
    register_block_pattern_category(
        'post165',
        array( 'label' => __( 'Post 165', 'post165' ) )
    );
}
add_action( 'init', 'post165_register_pattern_categories' );
