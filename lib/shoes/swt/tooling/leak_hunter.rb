require 'swt'
require 'shoes/swt'

$callers = {}
$untracked_disposals = {}

-> do
  # All known subclasses of Swt::Graphics::Resource
  # see http://help.eclipse.org/helios/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fswt%2Fpackage-summary.html
  classes = [
    ::Swt::Graphics::Color,
    ::Swt::Graphics::Cursor,
    ::Swt::Graphics::Font,
    ::Swt::Graphics::Image,
    ::Swt::Graphics::Path,
    ::Swt::Graphics::Pattern,
    ::Swt::Graphics::Region,
    ::Swt::Graphics::TextLayout,
    ::Swt::Graphics::Transform,

    # Excluded GC as we don't create any directly and it's quite noisy
    #::Swt::Graphics::GC,
  ]

  create_key = ->(klass, backtrace) do
    "[#{klass}]\n" + backtrace.join("\n\t")
  end

  classes.each do |klass|
    klass.class_eval do
      define_singleton_method(:new) do |*args|
        key = create_key.call(self.name, caller)
        $callers[key] ||= 0
        $callers[key] += 1

        result = super(*args)
        result.instance_variable_set(:@__shoes_creation_backtrace, key)
        result
      end

      define_method(:dispose) do |*args|
        if $callers[@__shoes_creation_backtrace]
          $callers[@__shoes_creation_backtrace] -= 1
        else
          key = create_key.call(self.class.name, caller)
          $untracked_disposals[key] ||= 0
          $untracked_disposals[key] += 1
        end
        super(*args)
      end
    end
  end
end.call

at_exit do
  count_for_class_and_backtrace = ->(hash) do
    hash.map do |k, v|
      if v > 0
        "#{v} => #{k}"
      end
    end.compact.join("\n\n")
  end

  totals = ->(hash) do
    hash.inject({}) do |memo, (k, v)|
      klass = k.split("\n").first
      memo[klass] ||= 0
      memo[klass] += v
      memo
    end.map do |k, v|
      v == 0 ? nil : " %-42s %5d" % [k, v]
    end.compact.join("\n")
  end

  puts "Undisposed resources:"
  puts count_for_class_and_backtrace.call($callers)
  puts
  puts "Resources disposed without being tracked:"
  puts count_for_class_and_backtrace.call($untracked_disposals)
  puts
  puts "Undisposed resource totals:"
  puts totals.call($callers)
  puts
  puts "Untracked disposal totals:"
  puts totals.call($untracked_disposals)
end

# Register an internal keystroke for closing the app, making sure to clear
# out the contents first (to avoid false positives for still-exiting elements.
Shoes::InternalApp.add_global_keypress(:'control_alt_q') do
  clear
  quit
end
