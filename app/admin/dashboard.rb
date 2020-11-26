ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel 'Productos SIN STOCK' do
          ul do
            Product.where('stock = 0 OR custom_stock = 0').map do |prod|
              li link_to(prod.name, admin_product_path(prod))
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Últimos 10 Pedidos de compra NUEVOS' do
          ul do
            PurchaseOrder.new_one.order('created_at DESC').first(10).map do |pur_ord|
              li link_to(pur_ord.id, admin_purchase_order_path(pur_ord))
            end
          end
        end
      end

      column do
        panel 'Últimos 10 Pedidos de compra SOLICITADOS' do
          ul do
            PurchaseOrder.requested.order('requested_at DESC').first(10).map do |pur_ord|
              li link_to(pur_ord.id, admin_purchase_order_path(pur_ord))
            end
          end
        end
      end

      column do
        panel 'Últimos 10 Pedidos de compra PAGADOS' do
          ul do
            PurchaseOrder.paid.order('paid_at DESC').first(10).map do |pur_ord|
              li link_to(pur_ord.id, admin_purchase_order_path(pur_ord))
            end
          end
        end
      end
    end
  end
end
