# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Desktop.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Desktop is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Desktop. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Desktop, please visit:
# https://github.com/alces-flight/flight-desktop
# ==============================================================================
require_relative '../command'

module Desktop
  module Commands
    class Clean < Command
      def run
        if session
          clean(session)
        else
          if Session.all.empty?
            $stderr.puts "No desktop sessions found."
          else
            Session.each { |s| clean(s) }
          end
        end
        if json?
          puts [*cleaned, *failed].to_json
        else
          skipped.each do |target, msg|
            $stderr.puts "#{target.uuid}: #{msg}"
          end
          failed.each do |target|
            $stderr.puts "#{target.uuid}: cleaning failed"
          end
          cleaned.each do |target|
            puts "#{target.uuid}: cleaned"
          end
        end
      end

      private

      def uuid
        @uuid ||= args[0][0] == ':' ? nil : args[0]
      end

      def display
        @display ||= args[0][0] == ':' ? args[0][1..-1] : nil
      end

      def session
        @session ||=
          if args[0]
            if uuid
              Session[uuid]
            elsif display
              Session.find_by_display(display, include_exited: true)
            end.tap do |s|
              raise SessionNotFoundError, "unknown local session: #{args[0]}" if s.nil?
            end
          end
      end

      def clean(target)
        if !target.local?
          skipped << [target, 'not local']
        elsif !target.active?
          if target.clean
            cleaned << target
          else
            failed << target
          end
        else
          skipped << [target, 'currently active']
        end
      end

      def cleaned
        @cleaned ||= []
      end

      def failed
        @failed ||= []
      end

      def skipped
        @skipped ||= []
      end
    end
  end
end
