# quokka:skip-module-directive-reordering
defmodule Backpex.Fields.Password do
  @config_schema [
    placeholder: [
      doc: "Placeholder value or function that receives the assigns.",
      type: {:or, [:string, {:fun, 1}]}
    ],
    autocomplete: [
      doc: "The value for the `autocomplete` attribute of the input or function that receives the assigns.",
      type: {:or, [:string, {:fun, 1}]}
    ],
    debounce: [
      doc: "Timeout value (in milliseconds), \"blur\" or function that receives the assigns.",
      type: {:or, [:pos_integer, :string, {:fun, 1}]}
    ],
    throttle: [
      doc: "Timeout value (in milliseconds) or function that receives the assigns.",
      type: {:or, [:pos_integer, {:fun, 1}]}
    ],
    readonly: [
      doc: "Sets the field to readonly. Also see the [panels](/guides/fields/readonly.md) guide.",
      type: {:or, [:boolean, {:fun, 1}]}
    ]
  ]

  @moduledoc """
  A field for handling a password value.

  ## Field-specific options

  See `Backpex.Field` for general field options.

  #{NimbleOptions.docs(@config_schema)}

  ## Example

      @impl Backpex.LiveResource
      def fields do
        [
          password: %{
            module: Backpex.Fields.Password,
            label: "Password",
            placeholder: "Enter a password",
            autocomplete: "new-password"
          }
        ]
      end
  """
  use Backpex.Field, config_schema: @config_schema

  @impl Backpex.Field
  def render_value(assigns) do
    ~H"""
    <p class={@live_action in [:index, :resource_action] && "truncate"}>
      {HTML.pretty_value(@value)}
    </p>
    """
  end

  @impl Backpex.Field
  def render_form(assigns) do
    ~H"""
    <div>
      <Layout.field_container>
        <:label :if={not @hide_label} align={Backpex.Field.align_label(@field_options, assigns, :center)}>
          <Layout.input_label for={@form[@name]} text={@field_options[:label]} />
        </:label>
        <BackpexForm.input
          type="password"
          field={@form[@name]}
          placeholder={@field_options[:placeholder]}
          autocomplete={autocomplete(@field_options, assigns)}
          translate_error_fun={Backpex.Field.translate_error_fun(@field_options, assigns)}
          help_text={Backpex.Field.help_text(@field_options, assigns)}
          phx-debounce={Backpex.Field.debounce(@field_options, assigns)}
          phx-throttle={Backpex.Field.throttle(@field_options, assigns)}
          readonly={@readonly}
          disabled={@readonly}
          aria-labelledby={Map.get(assigns, :aria_labelledby)}
        />
      </Layout.field_container>
    </div>
    """
  end

  defp autocomplete(%{autocomplete: autocomplete}, _assigns) when is_binary(autocomplete), do: autocomplete

  defp autocomplete(%{autocomplete: autocomplete}, assigns) when is_function(autocomplete, 1),
    do: autocomplete.(assigns)

  defp autocomplete(_field, _assigns), do: nil
end
