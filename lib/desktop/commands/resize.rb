# =============================================================================
# Copyright (C) 2022-present Alces Flight Ltd.
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
require 'commander'
require_relative '../command'
require_relative '../session'
require_relative '../session_finder'

module Desktop
  module Commands
    class Resize < Command
      include Concerns::SessionFinder
      def run
        args_needed = @options.avail ? 1 : 2
        if @options.avail
          if args.length > args_needed
            raise Commander::Command::CommandUsageError, "excess arguments for command 'resize'"
          end
          puts session.available_geometries
        else
          if args.length < args_needed
            raise Commander::Command::CommandUsageError, "insufficient arguments for command 'resize'"
          end
          session.resize(args[1])
        end
      end
    end
  end
end
